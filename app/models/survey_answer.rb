class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :survey_question
  belongs_to :survey_option
  belongs_to :user, optional: true

  validates :user, uniqueness: {
    scope: :survey_question,
    message: "может дать только один ответ на вопрос"
  }, if: -> { !survey_question.multichoice? }

  validates :user, uniqueness: {
    scope: %i[survey_question survey_option],
    message: "уже дал указанный ответ на этот вопрос"
  }
end
