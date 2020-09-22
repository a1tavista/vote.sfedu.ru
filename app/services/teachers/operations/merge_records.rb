module Teachers
  module Operations
    class MergeRecords
      include Dry::Transaction::Operation

      def call(original:, duplicate:)
        ActiveRecord::Base.transaction do
          merge_participations(original, duplicate)
          merge_relations(original, duplicate)
          merge_ratings(original, duplicate)
          merge_accounts(original, duplicate)
        end
      end

      private

      def merge_participations(original, duplicate)
        Participation.where(teacher_id: duplicate.id).update(teacher_id: original.id)
      end

      def merge_relations(original, duplicate)
        StudentsTeachersRelation.where(teacher_id: duplicate.id).update(teacher_id: original.id)
      end

      def merge_ratings(original, duplicate)
        Answer.all.where(teacher_id: duplicate.id).each do |dup_answer|
          original_answer = Answer.where(question_id: dup_answer.question_id, teacher_id: original.id).first
          next if original_answer.nil?

          original_ratings = original_answer.ratings
          duplicate_ratings = dup_answer.ratings
          original_answer.update(ratings: original_ratings.zip(duplicate_ratings).map { |p| p[0] + p[1] })
        end
      end

      def merge_accounts(original, duplicate)
        original.update(kind: duplicate.kind)
        duplicate.destroy
      end
    end
  end
end
