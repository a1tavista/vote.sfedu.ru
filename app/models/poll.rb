class Poll < ApplicationRecord
  has_many :faculty_participants, class_name: 'Poll::FacultyParticipant'
  has_many :options, class_name: 'Poll::Option'
  has_many :faculties, through: :faculty_participants

  def student_participated_in_poll?(student)
    Poll::Participation.find_by(student: student, poll: self).present?
  end
end
