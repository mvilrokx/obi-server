$:<<::File.dirname(__FILE__)

require 'sinatra/base'
require "json"
require 'savon'
require 'nori'

require 'app/models/query'
require 'app/models/session'

class ObiServer < Sinatra::Base


  MAJOR_VERSION = 0
  MINOR_VERSION = 1
  VERSION_REGEX = %r{/api/v(\d)\.(\d)}

  configure :production, :development do
    enable :logging
    disable :protection
  end

  # configure :production do
  #   use Throttler, :min => 300.0, :cache => Memcached.new, :key_prefix => :throttle
  # 	disable :show_exceptions
  # end

	configure do
		enable :sessions
		set :session_secret, 'hiwer80238fncmf919290459=oiutjkbds\[p90]28@#$%ew%wqer^wqe^wer&wer*r('
	end

	before do
		content_type :json
	end

	# Allows a user to logon.
	# Creates a session which will be used to stash the OBI server and the user
	# An optional callback URI can be passed
	# We also return the session ID in json
	post '/logon' do
		# strip last '/' if there is one
		# session[:hostname] = params[:hostname].sub!(/\/?$/, '') if params[:hostname]

		responder(Session.logon(params)) do |r|
			session[:bi_session_token] = r.body[:logon_result][:session_id]
			# redirect params[:callback] if params[:callback]
			{:bi_session_token => r.body[:logon_result][:session_id], :hostname => params[:hostname]}.to_json
		end

	end

	# Allows a user to logon. Clears the session
	post '/logoff' do
		responder(Session.logoff(params)) do |r|
			session.clear
			{:status => "ok"}.to_json
		end
	end

	# Allows a user to logon. Clears the session
	post '/get_cur_user' do
		responder(Session.get_cur_user(params)) do |r|
			{:user_fullname => r.body[:get_cur_user_result][:return]}.to_json
		end
	end

	# Allows an authenticated user to execute a query on the OBI server.
	# Will return the results of the query as json
	post '/query' do
		# protected!

		responder(Query.execute_sql_query(params, session)) do |r|
			parser = Nori.new()
			parser.parse(r.body[:execute_sql_query_result][:return][:rowset])["rowset"]["Row"].to_json
		end

	end

  helpers do
    def version_compatible?(nums)
      return MAJOR_VERSION == nums[0].to_i && MINOR_VERSION >= nums[1].to_i
    end

	  # def logged_in?
	  # 	session.has_key?(:bi_session_token)
	  # end

	  # def protected!
	  # 	halt [ 401, 'Not Authorized' ] unless logged_in?
	  # end
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