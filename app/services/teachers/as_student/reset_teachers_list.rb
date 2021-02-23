module Teachers
  module AsStudent
    class ResetTeachersList
      include Dry::Transaction

      class Contract < Dry::Validation::Contract
        params do
          required(:student).filled(type?: Student)
          required(:stage).filled(type?: Stage)
        end
      end

      step :validate_input
      step :update_fetching_status
      tee :publish_event

      def validate_input(input)
        ::Operations::ValidateInput.new.call(input, contract_klass: Contract)
      end

      def update_fetching_status(input)
        stage_attendee = StageAttendee.find_or_initialize_by(student: input[:student], stage: input[:stage])
        stage_attendee.update(fetching_status: :in_progress)

        Success(input)
      end

      def publish_event(input)
        input[:student].publish_event(Events::StudentRequestedTeachers)
      end
    end
  end
end
