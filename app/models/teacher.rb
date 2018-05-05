class Teacher < ApplicationRecord
  has_one :user, as: :kind, dependent: :destroy
  has_many :students_teachers_relations, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :stages, -> { distinct }, through: :participations

  enum kind: %i(common physical_education foreign_language)

  def stage_relations(stage)
    students_teachers_relations.where(semester: stage.semesters)
  end

  def relations_by_semesters
    students_by_semesters = students_teachers_relations.group(:semester_id).order(:semester_id).count
    semesters = Semester.all.index_by(&:id)
    current_stage = Stage.current
    students_by_semesters.map do |k, v|
      {
        semester: semesters[k].full_title.capitalize,
        is_current: current_stage&.semester_ids&.include?(k) || false,
        count: v
      }
    end
  end

  def evaluate_by(student, stage, answers)
    ActiveRecord::Base.transaction do
      answers.uniq! { |a| a[:question_id] }
      ids = answers.map { |a| a[:question_id] }
      unless ids.sort == stage.questions.pluck(:id).sort
        raise 'Answer questions and stage questions are different'
      end
      answers.each do |a|
        Answer.save_rating_for!(stage, self, Question.find(a[:question_id]), a[:rate])
      end
      Participation.create!(stage: stage, student: student, teacher: self)
    end
  end

  def relations_count
    students_teachers_relations.pluck(:student_id).count
  end

  def clear_snils!
    update(snils: self.class.clear_snils(snils)) unless snils.nil?
  end

  def encrypt_snils!
    update(encrypted_snils: Digest::SHA1.hexdigest(snils))
  end

  def self.clear_snils(snils)
    return nil if snils.nil?
    truncated = snils.gsub(' ', '').gsub('-', '')
    return nil if truncated.empty?
    truncated
  end

  def self.calculate_encrypted_snils(snils)
    snils_truncated = clear_snils(snils)
    return nil if snils_truncated.nil?
    Digest::SHA1.hexdigest(snils_truncated)
  end
end
