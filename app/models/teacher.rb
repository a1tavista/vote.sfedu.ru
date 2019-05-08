class Teacher < ApplicationRecord
  has_one :user, as: :kind, dependent: :destroy
  has_many :students_teachers_relations, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :stages, -> { distinct }, through: :participations

  enum kind: [:common, :physical_education, :foreign_language]

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

  def relations_count
    students_teachers_relations.pluck(:student_id).count
  end

  def normalize_snils!
    update(snils: Snils.normalize(snils)) unless snils.nil?
  end

  def encrypt_snils!
    update(encrypted_snils: Snils.encrypt(snils))
  end
end
