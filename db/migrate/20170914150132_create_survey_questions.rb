class CreateSurveyQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_questions do |t|
      t.belongs_to :survey, null: false, index: true
      t.string :text
      t.boolean :required, null: false, default: true
      t.boolean :multichoice, null: false, default: false
      t.boolean :free_answer, null: false, default: false
      t.timestamps
    end
  end
end
