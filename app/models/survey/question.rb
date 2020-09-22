class Survey
  class Question < ApplicationRecord
    self.table_name = "survey_questions"

    has_many :answers, class_name: "Survey::Answer", dependent: :destroy
    has_many :options, class_name: "Survey::Option", dependent: :destroy
    belongs_to :survey

    accepts_nested_attributes_for :options, reject_if: :all_blank

    validates :text, presence: true
  end
end
