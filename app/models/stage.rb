class Stage < ApplicationRecord
  has_and_belongs_to_many :semesters
  has_and_belongs_to_many :questions

  # Валидация на значения min_scale, max_scale и т.д.

  after_save :recalculate_scale_ladder!

  def self.current
    current_time = Time.current
    Stage
      .where('stages.starts_at <= ?', current_time)
      .where('stages.ends_at >= ?', current_time)
      .first
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
