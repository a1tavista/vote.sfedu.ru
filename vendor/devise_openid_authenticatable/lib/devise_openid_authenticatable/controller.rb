module DeviseOpenidAuthenticatable
  module Controller
    extend ActiveSupport::Concern

    included do
      alias_method :verify_authenticity_token_without_openid_response_check, :verify_authenticity_token
      alias_method :verify_authenticity_token, :verify_authenticity_token_with_openid_response_check
    end

    protected
    

    def verify_authenticity_token_with_openid_response_check
      verify_authenticity_token_without_openid_response_check unless openid_provider_response?
    end

    def openid_provider_response?
      !!request.env[Rack::OpenID::RESPONSE]
    end
  end
end
