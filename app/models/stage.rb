class Stage < ApplicationRecord
  has_and_belongs_to_many :semesters
  has_and_belongs_to_many :questions
  has_many :participations

  # Валидация на значения min_scale, max_scale и т.д.

  after_save :recalculate_scale_ladder!

  def self.upcoming
    Stage.where("stages.starts_at > ?", Time.current)
  end

  def self.past
    Stage.where("stages.ends_at < ?", Time.current)
  end

  def self.current
    current_time = Time.current
    Stage
      .where("stages.starts_at <= ?", current_time)
      .where("stages.ends_at >= ?", current_time)
      .first
  end

  def faculty_breakdown(from_period: nil)
    Faculty.find_each.map do |faculty|
      participants_count = faculty.participants(self, from_period: from_period).count
      participations_count = faculty.participations_by_stage(self, from_period: from_period).count
      average_answers = participants_count.zero? ? 0.0 : participations_count.to_f / participants_count

      {
        name: faculty.name,
        participants_count: participants_count,
        average_answers: average_answers
      }
    end
  end

  def total_participants
    participations.select(:student_id).distinct.count
  end

  def total_average_answers
    participants_count = total_participants
    if participants_count.zero?
      participations.where(stage: self).count.to_f / participants_count
    else
      0.0
    end
  end

  def current?
    current_time = Time.current
    starts_at <= current_time && current_time <= ends_at
  end

  def past?
    current_time = Time.current
    ends_at < current_time
  end

  def converted_scale_ladder
    scale_ladder.map do |range|
      range_begin, range_end = range.split("...")
      exclude_end = !range_end.nil?
      range_begin, range_end = range.split("..") if range_end.nil?
      Range.new(range_begin.to_f, range_end.to_f, exclude_end)
    end
  end

  def recalculate_scale_ladder!
    step = ((scale_max - scale_min) / scale_max.to_f)
    current = scale_min.to_f
    ladder = []
    while (current + step) < scale_max
      ladder.push((current...(current + step).round(4)))
      current = (current + step).round(4)
    end
    ladder.push((current..(current + step)))
    update_attribute(:scale_ladder, ladder)
  end
end
