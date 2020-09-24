module Polls
  module AsAdmin
    class AddOptionToPoll
      include Dry::Transaction

      class Contract < Dry::Validation::Contract
        config.messages.backend = :i18n

        params do
          required(:poll).filled(type?: Poll)

          required(:title).filled(:string)
          optional(:image).maybe(type?: Object)
          optional(:description).filled(:string)
        end
      end

      step :validate_input
      check :poll_not_started
      step :create_poll_option

      def validate_input(input)
        ::Operations::ValidateInput.new.call(input, contract_klass: Contract)
      end

      def poll_not_started(poll:, **)
        poll.starts_at > Time.current
      end

      def create_poll_option(input)
        poll_option = Poll::Option.create(input)
        poll_option.persisted? ? Success(input.merge(poll_option: poll_option)) : Failure()
      end
    end
  end
end
