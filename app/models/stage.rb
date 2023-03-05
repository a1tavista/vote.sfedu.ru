class Stage < ApplicationRecord
  has_and_belongs_to_many :semesters
  has_and_belongs_to_many :questions
  has_many :participations
  has_many :teachers_rosters, dependent: :destroy

  after_save :recalculate_scale_ladder!

  def self.upcoming
    where("stages.starts_at > ?", Time.current)
  end

  def self.past
    where("stages.ends_at < ?", Time.current)
  end

  def self.active
    current_time = Time.current
    where("stages.starts_at <= ?", current_time).where("stages.ends_at >= ?", current_time)
  end

  def self.current
    active.first
  end

  def upcoming?
    Time.current < starts_at
  end

  def current?
    current_time = Time.current
    starts_at <= current_time && current_time <= ends_at
  end

  def past?
    ends_at < Time.current
  end

  def calculation_rule_klass
    CalculationRules::V2019Spring
  end

  def converted_scale_ladder
    return unless with_scale?

    calculation_rule_klass.converted_scale_ladder(stage: self)
  end

  def recalculate_scale_ladder!
    return unless with_scale?

    ladder = calculation_rule_klass.recalculate_scale_ladder!(stage: self)
    update_attribute(:scale_ladder, ladder)
  end
end
