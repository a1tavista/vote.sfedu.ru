class Stage < ApplicationRecord
  has_and_belongs_to_many :semesters
  has_and_belongs_to_many :questions

end
