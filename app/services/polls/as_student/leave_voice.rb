module Polls
  module AsStudent
    class LeaveVoice
      include Dry::Transaction

      class Contract < Dry::Validation::Contract
        config.messages.backend = :i18n

        params do
          required(:student).filled(type?: Student)
          required(:poll).filled(type?: Poll)
          required(:poll_option).filled(type?: Poll::Option)
        end
      end

      step :validate_input
      check :poll_not_closed_yet
      check :option_belongs_to_poll
      check :student_not_participated_before
      check :student_allowed_to_leave_voice
      step :record_student_vote

      def validate_input(input)
        Operations::ValidateInput.new.call(input, contract_klass: Contract)
      end

      def option_belongs_to_poll(input)
        input[:poll].options.find_by_id(input[:poll_option].id).present?
      end

      def poll_not_closed_yet(input)
        input[:poll].starts_at < Time.current && Time.current < input[:poll].ends_at
      end

      def student_allowed_to_leave_voice(input)
        student_faculty_ids = input[:student].faculty_ids
        (input[:poll].faculty_ids & student_faculty_ids).any?
      end

      def student_not_participated_before(input)
        Poll::Participation.find_by(student: input[:student], poll: input[:poll]).blank?
      end

      def record_student_vote(input)
        participation = Poll::Participation.new(student: input[:student], poll: input[:poll])
        answer = Poll::Answer.new(poll: input[:poll], poll_option: input[:poll_option])

        ActiveRecord::Base.with_advisory_lock(with_lock_name(input[:student], input[:poll])) do
          ActiveRecord::Base.transaction do
            participation.save
            answer.save
          end
        end

        answer.persisted? ? Success(input.merge(answer_uuid: answer.id)) : Failure(input)
      end

      private

      def with_lock_name(student, poll)
        "lock_for_participation_in_poll_#{poll.id}_by_student_#{student.id}"
      end
    end
  end
end
