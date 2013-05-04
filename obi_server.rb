$:<<::File.dirname(__FILE__)

# require 'sinatra'
require 'sinatra/base'
require "json"
require 'savon'
require 'nori'

require 'app/models/query'
require 'app/models/session'

class ObiServer < Sinatra::Base

  # set :show_exceptions, false

  MAJOR_VERSION = 0
  MINOR_VERSION = 1
  VERSION_REGEX = %r{/api/v(\d)\.(\d)}

  configure :production, :development do
    enable :logging
  end

  # configure :production do
  #   use Throttler, :min => 300.0, :cache => Memcached.new, :key_prefix => :throttle
  # end

	configure do
		enable :sessions
		set :session_secret, 'hiwer80238fncmf919290459=oiutjkbds\[p90]28@#$%ew%wqer^wqe^wer&wer*r('
	end

	before do
		content_type :json
	end

	post '/logon' do
		# strip last '/' if there is one
		session[:hostname] = params[:hostname].sub!(/\/?$/, '') if params[:hostname]

		responder(Session.logon(params, session)) do |r|
			session[:bi_session_token] = r.body[:logon_result][:session_id]
			redirect params[:callback] if params[:callback]
			{:bi_session_token => session[:bi_session_token]}.to_json
		end

	end

	post '/logoff' do
		Session.logoff(session)
	end

	post '/query' do
		protected!

		responder(Query.execute_sql_query(params,session)) do |r|
			parser = Nori.new()
			parser.parse(r.body[:execute_sql_query_result][:return][:rowset])["rowset"]["Row"].to_json
		end

	end

  helpers do
    def version_compatible?(nums)
      return MAJOR_VERSION == nums[0].to_i && MINOR_VERSION >= nums[1].to_i
    end

	  def logged_in?
	  	session.has_key?(:bi_session_token)
	  end

	  def protected!
	  	halt [ 401, 'Not Authorized' ] unless logged_in?
	  end
  end

  before VERSION_REGEX do
    if version_compatible?(params[:captures])
      request.path_info = request.path_info.match(VERSION_REGEX).post_match
    else
      halt 400, "Version not compatible with this server"
    end
  end

private
  def responder(r)
		if r.is_a?(Savon::Response)
			yield(r) if block_given?
		else # something went wrong with the SOAP request
			case r[:faultstring]
			when 'Error occurred while processing the query.'
				status 400
			when 'Authentication error. An invalid User Name or Password was entered.'
				status 401
			when 'Invalid session ID'
				status 401
			else
				status 500
			end
			r.to_json
		end
  end

	# start the server if ruby file executed directly
  run! if __FILE__ == $0
end