module Polls
  module AsAdmin
    class CreatePoll
      include Dry::Transaction

      class Contract < Dry::Validation::Contract
        config.messages.backend = :i18n

        params do
          required(:name).filled(:string)
          required(:starts_at).value(:time)
          required(:ends_at).value(:time)

          required(:faculty_ids).array(:integer)
        end
      end

      step :validate_input
      check :starts_in_future
      check :dates_are_valid
      check :all_faculties_are_present

      step :create_poll

      def validate_input(input)
        ::Operations::ValidateInput.new.call(input, contract_klass: Contract)
      end

      def starts_in_future(starts_at:, **)
        starts_at >= Time.current.tomorrow.beginning_of_day
      end

      def dates_are_valid(starts_at:, ends_at:, **)
        starts_at < ends_at
      end

      def all_faculties_are_present(faculty_ids:, **)
        Faculty.where(id: faculty_ids).count == faculty_ids.count
      end

      def create_poll(input)
        poll = Poll.create(input)
        poll.persisted? ? Success(input.merge(poll: poll)) : Failure(input)
      end
    end
  end
end
