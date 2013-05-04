require 'savon'

class Session
  extend Savon::Model

	operations :logon, :logoff

  def self.logon(params, session)
		client ssl_verify_mode: :none,
		                  wsdl: "#{session[:hostname]}/analytics-ws/saw.dll/wsdl/v7"

    super( message: { name: params[:username], password: params[:password] })
	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

  def self.logoff(session)
		client ssl_verify_mode: :none,
		                  wsdl: "#{session[:hostname]}/analytics-ws/saw.dll/wsdl/v7"

    super( message: { session_iD: session[:bi_session_token] })
    session.clear

	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

end