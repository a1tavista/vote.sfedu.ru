class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :stage
  belongs_to :teacher
end
