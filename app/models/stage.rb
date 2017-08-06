class Stage < ApplicationRecord
  has_and_belongs_to_many :semesters
  has_and_belongs_to_many :questions

  def self.current
    current_time = Time.current
    Stage
      .where('stages.starts_at >= ?', current_time)
      .where('stages.ends_at <= ?', current_time)
      .first
  end
end
