class Question < ApplicationRecord
  has_and_belongs_to_many :stages
  has_many :answers
end
