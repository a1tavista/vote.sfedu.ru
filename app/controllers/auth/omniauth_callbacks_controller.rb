module Auth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def azure_oauth2
      ::Users::AuthenticateUser.new.call(authenticate_params) do |monad|
        monad.success do |result|
          sign_in_and_redirect result[:user], event: :authentication
        end

        monad.failure do |result|
          render json: result.merge(authenticate_params: authenticate_params)
          # flash[:alert] = @user.errors.full_messages.join("<br>")
          # Rails.logger.error "Couldn't login user: " + @user.errors.inspect
          # redirect_back(fallback_location: root_path, allow_other_host: false)
        end
      end
    end

    def authenticate_params
      auth_hash = request.env['omniauth.auth'].to_hash

      {
        user_attributes: {
          email: auth_hash.dig("extra", "raw_info", "email"),
          name: auth_hash.dig("extra", "raw_info", "name"),
          azure_id: auth_hash["uid"],
          available_roles: auth_hash.dig("extra", "raw_info").values_at("extensionAttribute1", "extensionAttribute2").compact,
          sfedu_student_id: auth_hash.dig("extra", "raw_info", "r61StudentId"),
          sfedu_global_key: auth_hash.dig("extra", "raw_info", "r61GlobalKey"),
        },
        ip_address: auth_hash.dig("extra", "raw_info", "ipaddr"),
      }
    end
  end
end

