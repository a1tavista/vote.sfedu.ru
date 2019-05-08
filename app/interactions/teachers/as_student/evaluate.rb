module Teachers
  module AsStudent
    class Evaluate < BaseInteraction
      record :teacher
      record :student
      record :stage
      array :answers

      def execute
        ActiveRecord::Base.transaction do
          answers = inputs[:answers].uniq { |a| a[:question_id] }
          ids = answers.map { |a| a[:question_id] }

          unless ids.sort == stage.questions.pluck(:id).sort
            raise 'Answer questions and stage questions are different'
          end

          answers.each do |a|
            answer = Answer.where(
              stage: stage,
              teacher: teacher,
              question: Question.find(a[:question_id])
            ).first_or_create!

            answer.ratings[a[:rate] - 1] += 1
            answer.save
          end

          Participation.create!(stage: stage, student: student, teacher: teacher)
        end
      end
    end
  end
end
