class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :text, null: false
      t.integer :max_rating, null: false, default: 10
      t.timestamps
    end
  end
end
