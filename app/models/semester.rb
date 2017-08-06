class Semester < ApplicationRecord
  has_and_belongs_to_many :stages
  enum kind: %i(fall spring)
end
