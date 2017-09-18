class CreateSurveyOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_options do |t|
      t.belongs_to :survey_question
      t.string :text
      t.boolean :custom, null: false, default: false
      t.timestamps
    end
  end
end
