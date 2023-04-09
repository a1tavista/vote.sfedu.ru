module Users
  class AuthenticateUser
    include Dry::Transaction

    class Contract < Dry::Validation::Contract
      params do
        required(:user_attributes).hash do
          required(:email).filled(:string)
          required(:name).filled(:string)
          required(:azure_id).filled(:string)
          required(:available_roles).array(:str?)
          # TODO: Normalize
          required(:sfedu_student_id).filled(:string)
          # TODO: Pass through type and handle
          required(:sfedu_global_key).filled(:string)
        end

        # TODO: Verify as IP
        required(:ip_address).filled(:string)
      end
    end

    step :validate_input
    step :find_or_create_user
    step :persist_user_data

    def validate_input(input)
      ::Operations::ValidateInput.new.call(input, contract_klass: Contract)
    end

    def find_or_create_user(input)
      user = User.find_or_initialize_by(email: input[:user_attributes][:email]) do |u|
        u.assign_attributes(identity_data_by(input[:user_attributes][:email]))
      end

      Success(input.merge(user: user))
    end

    def persist_user_data(input)
      user = input[:user]

      actualize_personal_data_of(user, name: input[:user_attributes][:name], ip_address: input[:ip_address])
      setup_student_account_for(user, student_id: input[:user_attributes][:sfedu_student_id]) if has_student_account?(input)

      ActiveRecord::Base.transaction do
        user.save
        user.publish_event(Events::UserAuthenticated)
      end

      Success(input)
    end

    private

    def identity_data_by(email)
      nickname = email.split('@').first

      {
        identity_url: "https://openid.sfedu.ru/server.php/idpage?user=#{nickname}",
        nickname: nickname
      }
    end

    def normalize_id(raw_id)
      raw_id.gsub(/[^0-9]/, "").rjust(9, "0")
    end

    def actualize_personal_data_of(user, name:, ip_address:)
      user.assign_attributes(name: name, last_sign_in_ip: ip_address)
    end

    def setup_student_account_for(user, student_id:)
      student_record = Student.find_or_initialize_by(external_id: normalize_id(student_id))
      user.assign_attributes(kind: student_record, student: student_record)
    end

    def has_student_account?(input)
      input[:user_attributes][:available_roles].include?("student")
    end
  end
end
