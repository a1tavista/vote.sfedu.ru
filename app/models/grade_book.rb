class GradeBook < ApplicationRecord
  belongs_to :student
  belongs_to :faculty

  enum time_type: %i(fulltime parttime extramural distant other_time_type)
  enum grade_level: %i(applied_bachelor academic_bachelor specialist master postgraduate other_grade_level)
end
