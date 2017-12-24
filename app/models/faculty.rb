class Faculty < ApplicationRecord
  has_many :grade_books
  has_many :students, through: :grade_books

  def participants(stage, full_info: false)
    student_list = students
                     .distinct
                     .joins(:participations)
                     .where('participations.stage_id = ?', stage.id)
  end
end
