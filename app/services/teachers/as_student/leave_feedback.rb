module Teachers
  module AsStudent
    class LeaveFeedback
      include Dry::Transaction

      class Contract < Dry::Validation::Contract
        params do
          required(:student).filled(type?: Student)
          required(:stage).filled(type?: Stage)
          required(:teacher).filled(type?: Teacher)

          required(:answers).array(:hash) do
            required(:question_id).filled(:integer)
            required(:rate).filled(:integer) { gteq?(1) & lteq?(10) }
          end
        end
      end

      step :validate_input
      check :stage_not_closed_yet
      check :student_not_participated_before
      check :student_allowed_to_leave_feedback
      check :student_filled_all_questions
      step :record_feedback

      def validate_input(input)
        ::Operations::ValidateInput.new.call(input, contract_klass: Contract)
      end

      def stage_not_closed_yet(input)
        input[:stage].ends_at > Time.current
      end

      def student_not_participated_before(input)
        Participation.find_by(input.slice(:student, :teacher, :stage)).blank?
      end

      def student_allowed_to_leave_feedback(input)
        available_teachers = ::Teachers::AvailableTeachersForStudent.new(stage: input[:stage], student: input[:student]).call

        available_teachers.find_by_id(input[:teacher]).present?
      end

      def student_filled_all_questions(input)
        filled_question_ids = input[:answers].pluck(:question_id)
        stage_questions_ids = input[:stage].question_ids

        filled_question_ids.sort == stage_questions_ids.sort
      end

      def record_feedback(input)
        answers = input[:answers].uniq { |a| a[:question_id] }

        ActiveRecord::Base.transaction do
          # TODO: Only save answers inside transaction, don't fetch it
          answers.each do |answer_data|
            answer = Answer.where(
              stage: input[:stage],
              teacher: input[:teacher],
              question: input[:stage].questions.find(answer_data[:question_id])
            ).first_or_create!

            answer.ratings[answer_data[:rate] - 1] += 1
            answer.save
          end

          Participation.create!(stage: input[:stage], student: input[:student], teacher: input[:teacher])
        end

        Success()
      end
    end
  end
end
