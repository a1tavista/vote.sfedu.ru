class TeachersRoster < ApplicationRecord
  belongs_to :stage
  belongs_to :teacher
end
