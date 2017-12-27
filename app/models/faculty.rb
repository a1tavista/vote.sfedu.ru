class Faculty < ApplicationRecord
  has_many :grade_books
  has_many :students, through: :grade_books
  has_many :participations, through: :students

  def participants(stage, full_info: false)
    students
      .distinct
      .joins(:participations)
      .where('participations.stage_id = ?', stage.id)
  end

  def participations

  end
end
