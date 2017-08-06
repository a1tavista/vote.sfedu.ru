class Teacher < ApplicationRecord
  has_many :students_teachers_relations, dependent: :destroy
  has_many :answers, dependent: :destroy
end
