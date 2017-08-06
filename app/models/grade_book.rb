class GradeBook < ApplicationRecord
  belongs_to :student
  belongs_to :faculty

  enum time_type: %i(fulltime parttime extramural distant)
  enum grade_level: %i(applied_bachelor academic_bachelor specialist master postgraduate)
end
