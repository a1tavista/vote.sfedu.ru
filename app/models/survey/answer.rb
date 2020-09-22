class Survey
  class Answer < ApplicationRecord
    self.table_name = "survey_answers"

    belongs_to :survey
    belongs_to :survey_question, class_name: "Survey::Question"
    belongs_to :survey_option, class_name: "Survey::Option"
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
end
