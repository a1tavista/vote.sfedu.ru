class Semester < ApplicationRecord
  has_and_belongs_to_many :stages
  enum kind: %i[fall spring]

  def full_title
    "#{kind_title} семестр #{year_begin}/#{year_end}"
  end

  def kind_title
    fall? ? "осенний" : "весенний"
  end
end
