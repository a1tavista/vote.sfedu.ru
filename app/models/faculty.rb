class Faculty < ApplicationRecord
  has_many :grade_books
  has_many :students, through: :grade_books

  def participants_list(stage)
    student_list = students
      .distinct
      .joins(:participations)
      .joins(:grade_books)
      .where('participations.stage_id = ?', stage.id)

    student_list.map do |student|
      book = student.grade_books.where('grade_books.faculty_id = ?', self.id).first
      {
        id: student.id,
        name: student.name,
        major: book.major,
        grade_num: book.grade_num,
        group_num: book.group_num,
        time_type: book.time_type,
        grade_level: book.grade_level,
      }
    end
  end
end
