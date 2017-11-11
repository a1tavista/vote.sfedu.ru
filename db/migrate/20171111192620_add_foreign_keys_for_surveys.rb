class AddForeignKeysForSurveys < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :surveys, :users
    add_foreign_key :survey_questions, :surveys
    add_foreign_key :survey_answers, :surveys
    add_foreign_key :survey_answers, :survey_questions
    add_foreign_key :survey_answers, :survey_options
    add_foreign_key :survey_answers, :users
    add_foreign_key :survey_sharings, :surveys
    add_foreign_key :survey_sharings, :users
  end
end
