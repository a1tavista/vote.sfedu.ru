class Faculty < ApplicationRecord
  has_many :grade_books
  has_many :students, through: :grade_books
  has_many :participations, through: :students

  def participants(stage, from_period: nil)
    students = self.students
      .distinct
      .joins(:participations)
      .where('participations.stage_id = ?', stage.id)
    students = students.where('participations.created_at > ?', from_period) if from_period.present?
    students
  end

  def participations_by_stage(stage, from_period: nil)
    parts = participations.where('participations.stage_id = ?', stage.id)
    parts = parts.where('participations.created_at > ?', from_period) if from_period.present?
    parts
  end
end
