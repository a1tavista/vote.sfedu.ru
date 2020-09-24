module Polls
  module AsAdmin
    class EditOption
      include Dry::Transaction

      class Contract < Dry::Validation::Contract
        config.messages.backend = :i18n

        params do
          required(:poll_option).filled(type?: Poll::Option)
          optional(:description).filled(:string)
        end
      end

      step :validate_input
      step :edit_poll_option

      def validate_input(input)
        ::Operations::ValidateInput.new.call(input, contract_klass: Contract)
      end

      def edit_poll_option(poll_option:, description:)
        poll_option.update(description: description) ? Success(poll_option: poll_option) : Failure()
      end
    end
  end
end
