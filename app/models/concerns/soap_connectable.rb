module SoapConnectable
  extend ActiveSupport::Concern

  included do
    extend Savon::Model

    client wsdl: ENV.fetch('SFEDU_WSDL_PATH')

    global :env_namespace, :soap
    global :namespace_identifier, :perf
    global :convert_request_keys_to, :camelcase
  end
end
