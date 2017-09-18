class CreateSurveyAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_answers do |t|
      t.belongs_to :survey, null: false, index: true
      t.belongs_to :survey_question, null: false, index: true
      t.belongs_to :survey_option, null: false, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
