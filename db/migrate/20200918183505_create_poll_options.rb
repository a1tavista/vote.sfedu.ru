class CreatePollOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :poll_options do |t|
      t.belongs_to :poll, index: true, foreign_key: true
      t.string :title, null: false
      t.string :description
      t.text :image_data
      t.timestamps
    end
  end
end
