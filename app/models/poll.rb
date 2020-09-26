class Poll < ApplicationRecord
  has_many :faculty_participants, class_name: 'Poll::FacultyParticipant'
  has_many :options, class_name: 'Poll::Option'
  has_many :faculties, through: :faculty_participants
  has_many :answers, class_name: 'Poll::Answer'

  def self.for_student(student)
    joins(:faculties).where(faculties: { id: student.faculty_ids })
  end

  def student_participated_in_poll?(student)
    Poll::Participation.find_by(student: student, poll: self).present?
  end

  def finished?
    ends_at < Time.current
  end
end
