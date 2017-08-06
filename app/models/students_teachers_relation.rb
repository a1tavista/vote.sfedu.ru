class StudentsTeachersRelation < ApplicationRecord
  belongs_to :student
  belongs_to :teacher
  belongs_to :semester
end
