class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :text, null: false
      t.integer :min_evaluation, null: false, default: 1
      t.integer :max_evaluation, null: false, default: 10
      t.timestamps
    end
  end
end
