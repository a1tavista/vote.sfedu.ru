class Poll < ApplicationRecord
  has_many :faculty_participants, class_name: 'Poll::FacultyParticipant', dependent: :destroy
  has_many :options, class_name: 'Poll::Option', dependent: :destroy
  has_many :faculties, through: :faculty_participants
  has_many :answers, class_name: 'Poll::Answer', dependent: :destroy
  has_many :participations, class_name: 'Poll::Participation', dependent: :destroy

  scope :active, -> { where('starts_at < ?', Time.current).where('ends_at > ?', Time.current) }
  scope :not_archived, -> { where(archived_at: nil) }

  def self.for_student(student)
    most_recent_faculty = GradeBook.most_recent_for(student: student)&.faculty_id
    not_archived.joins(:faculties).where(faculties: { id: most_recent_faculty }).distinct
  end

  def student_participated_in_poll?(student)
    Poll::Participation.find_by(student: student, poll: self).present?
  end

  def current?
    current_time = Time.current
    starts_at <= current_time && current_time <= ends_at
  end

  def archived?
    archived_at.present?
  end

  def upcoming?
    Time.current < starts_at
  end

  def started?
    starts_at < Time.current
  end

  def finished?
    ends_at < Time.current
  end

  alias_method :past?, :finished?
end
