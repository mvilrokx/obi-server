require 'savon'

class Session
  extend Savon::Model

	operations :logon, :logoff, :get_cur_user

  def self.logon(params)
		client ssl_verify_mode: :none,
		                  wsdl: "#{params[:hostname]}/analytics-ws/saw.dll/wsdl/v7"

    super( message: { name: params[:username], password: params[:password] })
	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

  def self.get_cur_user(params)
		client ssl_verify_mode: :none,
		                  wsdl: "#{params[:hostname]}/analytics-ws/saw.dll/wsdl/v7"

    super( message: { session_iD: params[:bi_session_token] })

	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

  def self.logoff(params)
		client ssl_verify_mode: :none,
		                  wsdl: "#{params[:hostname]}/analytics-ws/saw.dll/wsdl/v7"

    super( message: { session_iD: params[:bi_session_token] })
    # session.clear

	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

end