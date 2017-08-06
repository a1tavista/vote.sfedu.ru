class Faculty < ApplicationRecord
  has_many :grade_books

  def participants_list(stage)
    # TODO: Сделать выгрузку по студентам-участникам анкетирования в стадии
  end
end
