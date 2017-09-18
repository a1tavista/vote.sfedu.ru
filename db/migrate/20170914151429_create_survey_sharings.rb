class CreateSurveySharings < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_sharings do |t|
      t.belongs_to :survey, null: false, index: true
      t.belongs_to :user, null: false, index: true
      t.timestamps
    end
  end
end
