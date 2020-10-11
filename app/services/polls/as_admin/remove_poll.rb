module Polls
  module AsAdmin
    class RemovePoll
      include Dry::Transaction

      class Contract < Dry::Validation::Contract
        config.messages.backend = :i18n

        params do
          required(:poll).value(type?: Poll)
        end
      end

      step :validate_input
      check :poll_not_started_yet
      step :destroy_poll

      def validate_input(input)
        ::Operations::ValidateInput.new.call(input, contract_klass: Contract)
      end

      def poll_not_started_yet(poll:, **)
        poll.starts_at > Time.current
      end

      def destroy_poll(poll:, **)
        poll.destroy

        Success(poll: poll)
      end
    end
  end
end
