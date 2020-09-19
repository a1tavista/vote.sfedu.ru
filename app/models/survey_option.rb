class SurveyOption < ApplicationRecord
  belongs_to :survey_question
  has_many :answers, class_name: "SurveyAnswer", dependent: :destroy

  validates :text, presence: true
end
