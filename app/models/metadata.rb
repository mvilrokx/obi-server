require 'savon'

class Metadata
  extend Savon::Model

	operations :get_subject_areas, :describe_table, :describe_subject_area, :describe_column

  def self.get_subject_areas(params, session)
		client ssl_verify_mode: :none,
		                  wsdl: "#{params[:hostname] || session[:hostname]}/analytics-ws/saw.dll/wsdl/v7",
		              endpoint: "#{params[:hostname] || session[:hostname]}/analytics-ws/saw.dll?SoapImpl=metadataService"

    super( message: { session_iD: params[:bi_session_token] || session[:bi_session_token] })
	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

  def self.describe_subject_area(params, session)
		client ssl_verify_mode: :none,
		                  wsdl: "#{params[:hostname] || session[:hostname]}/analytics-ws/saw.dll/wsdl/v7",
		              endpoint: "#{params[:hostname] || session[:hostname]}/analytics-ws/saw.dll?SoapImpl=metadataService"

    super( message: {
    					subject_area_name: params[:subject_area_name],
    					details_level: params[:details_level] || "IncludeTablesAndColumns",
    					session_iD: params[:bi_session_token] || session[:bi_session_token] })

	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

  def self.describe_table(params, session)
		client ssl_verify_mode: :none,
		                  wsdl: "#{params[:hostname] || session[:hostname]}/analytics-ws/saw.dll/wsdl/v7",
		              endpoint: "#{params[:hostname] || session[:hostname]}/analytics-ws/saw.dll?SoapImpl=metadataService"

    super( message: {
    					subject_area_name: params[:subject_area_name],
    					table_name: params[:table_name],
    					details_level: params[:details_level] || "IncludeTablesAndColumns",
    					session_iD: params[:bi_session_token] || session[:bi_session_token] })

	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

  def self.describe_column(params, session)
		client ssl_verify_mode: :none,
		                  wsdl: "#{params[:hostname] || params[:hostname]}/analytics-ws/saw.dll/wsdl/v7",
		              endpoint: "#{params[:hostname] || session[:hostname]}/analytics-ws/saw.dll?SoapImpl=metadataService"

    super( message: {
    					subject_area_name: params[:subject_area_name],
    					table_name: params[:table_name],
    					column_name: params[:column_name],
    					session_iD: params[:bi_session_token] || session[:bi_session_token] })

	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

end