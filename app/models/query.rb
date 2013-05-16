require 'savon'

class Query
  extend Savon::Model

	# client ssl_verify_mode: :none, wsdl: "#{session[:hostname]}/analytics-ws/saw.dll/wsdl/v7", endpoint: "#{session[:hostname]}/analytics-ws/saw.dll?SoapImpl=xmlViewService"
	operations :execute_sql_query, :execute_xml_query

  def self.execute_sql_query(params, session)
		client ssl_verify_mode: :none,
		                  wsdl: "#{params[:hostname]}/analytics-ws/saw.dll/wsdl/v7",
		              endpoint: "#{params[:hostname]}/analytics-ws/saw.dll?SoapImpl=xmlViewService"

    super( message: {
			sql!: params[:sql],
			output_format: params[:output_format] || "xml",
			execution_options: {
				async: params[:async] || "false",
				max_rows_per_page: params[:max_rows_per_page] || 1000,
				refresh: params[:refresh] || "false",
				presentation_info: params[:presentation_info] || "?",
				type: params[:type] || "?"
			},
			session_iD: params[:bi_session_token] || session[:bi_session_token]
		})
	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

  def self.execute_xml_query(params, session)
		client ssl_verify_mode: :none,
		                  wsdl: "#{params[:hostname]}/analytics-ws/saw.dll/wsdl/v7",
		              endpoint: "#{params[:hostname]}/analytics-ws/saw.dll?SoapImpl=xmlViewService"

    super( message: {
    	report:{
    		report_path: params[:report_path]
    	},
			output_format: params[:output_format] || "xml",
			execution_options: {
				async: params[:async] || "false",
				max_rows_per_page: params[:max_rows_per_page] || 1000,
				refresh: params[:refresh] || "false",
				presentation_info: params[:presentation_info] || "?",
				type: params[:type] || "?"
			},
			session_iD: params[:bi_session_token] || session[:bi_session_token]
		})
	rescue Savon::SOAPFault => error
	  error.to_hash[:fault]
  end

end