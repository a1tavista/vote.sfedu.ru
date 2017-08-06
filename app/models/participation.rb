class Participation < ApplicationRecord
  belongs_to :stage
  belongs_to :student
  belongs_to :teacher
end
