module Teachers
  module AsStudent
    class RemoveTeacherFromRelations
      include Dry::Transaction

      class Contract < Dry::Validation::Contract
        params do
          required(:student).filled(type?: Student)
          required(:stage).filled(type?: Stage)
          required(:teacher).filled(type?: Teacher)
        end
      end

      step :validate_input
      check :stage_not_closed_yet
      check :teacher_belongs_to_roster
      step :remove_relation

      def validate_input(input)
        ::Operations::ValidateInput.new.call(input, contract_klass: Contract)
      end

      def stage_not_closed_yet(input)
        input[:stage].ends_at > Time.current
      end

      def teacher_belongs_to_roster(input)
        TeachersRoster.exists?(stage: input[:stage], teacher: input[:teacher])
      end

      def remove_relation(input)
        relation = StudentsTeachersRelation.find_by(input.merge(origin: :roster)).destroy
        relation.destroyed? ? Success(input) : Failure(input)
      end
    end
  end
end
