class GradeBook < ApplicationRecord
  belongs_to :student
  belongs_to :faculty

  enum time_type: %i[fulltime parttime extramural distant other_time_type]
  enum grade_level: %i[applied_bachelor academic_bachelor specialist master postgraduate other_grade_level]

  REAL_EDUCATION_LEVELS = %i[applied_bachelor academic_bachelor specialist master postgraduate]

  def self.most_recent_for(student:)
    latest_level = latest_grade_level_for(student: student)
    where(student: student).where(grade_level: latest_level).order(grade_num: :desc).first
  end

  def self.latest_grade_level_for(student:)
    where(student: student)
      .where(grade_level: REAL_EDUCATION_LEVELS)
      .order(grade_level: :desc)
      .pluck(:grade_level)
      .first
  end
end
