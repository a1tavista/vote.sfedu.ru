class Teacher::MergeDuplicates
  def initialize
    @teachers_to_process = Teacher.where.not(kind: 0)
    @duplicates = Teacher.where(kind: 0, encrypted_snils: @teachers_to_process.pluck(:encrypted_snils))
  end

  def process!
    ActiveRecord::Base.transaction do
      pairs = (@teachers_to_process + @duplicates)
        .group_by(&:encrypted_snils)

      pairs.each do |hash, pair|
        next if pair.length != 2
        pair.sort! { |a, b| a.kind == 0 ? 0 : 1 }
        merge_participations(pair[0], pair[1])
        merge_relations(pair[0], pair[1])
        merge_ratings(pair[0], pair[1])
        merge_accounts(pair[0], pair[1])
      end
    end
  end

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
      orginal_ratings = original_answer.ratings
      duplicate_ratings = dup_answer.ratings
      original_answer.
        update(ratings: orginal_ratings.zip(duplicate_ratings).
        map { |p| p[0] + p[1] })
    end
  end

  def merge_accounts(original, duplicate)
    original.update(kind: duplicate.kind)
    duplicate.destroy
  end
end
