module OneCApi
  module SoapConnectable
    extend ActiveSupport::Concern

    included do
      extend Savon::Model

      client wsdl: ENV.fetch("SFEDU_WSDL_PATH", nil),
             soap_header: {username: ENV.fetch("SFEDU_WSDL_USERNAME", nil), password: ENV.fetch("SFEDU_WSDL_PASSWORD", nil)},
             basic_auth: [ENV.fetch("SFEDU_WSDL_USERNAME", nil), ENV.fetch("SFEDU_WSDL_PASSWORD", nil)]

      global :env_namespace, :soap
      global :namespace_identifier, :perf
      global :convert_request_keys_to, :camelcase
    end
  end
end
