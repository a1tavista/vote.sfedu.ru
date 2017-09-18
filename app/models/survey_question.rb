class SurveyQuestion < ApplicationRecord
  has_many :answers, class_name: 'SurveyAnswer', dependent: :destroy
  has_many :options, class_name: 'SurveyOption', dependent: :destroy
  belongs_to :survey

  validates :text, presence: true
end
