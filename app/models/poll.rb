class Poll < ApplicationRecord
  has_many :faculty_participants, class_name: 'Poll::FacultyParticipant', dependent: :destroy
  has_many :options, class_name: 'Poll::Option', dependent: :destroy
  has_many :faculties, through: :faculty_participants
  has_many :answers, class_name: 'Poll::Answer', dependent: :destroy
  has_many :participations, class_name: 'Poll::Participation', dependent: :destroy

  scope :active, -> { where('starts_at < ?', Time.current).where('ends_at > ?', Time.current) }

  def self.for_student(student)
    joins(:faculties).where(faculties: { id: student.faculty_ids }).distinct
  end

  def student_participated_in_poll?(student)
    Poll::Participation.find_by(student: student, poll: self).present?
  end

  def started?
    starts_at < Time.current
  end

  def finished?
    ends_at < Time.current
  end
end
