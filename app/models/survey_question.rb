class SurveyQuestion < ApplicationRecord
  has_many :answers, class_name: 'SurveyAnswer', dependent: :destroy
  has_many :options, class_name: 'SurveyOption', dependent: :destroy
  belongs_to :survey

  accepts_nested_attributes_for :options, reject_if: :all_blank

  validates :text, presence: true
end
