class CreateSurveys < ActiveRecord::Migration[5.1]
  def change
    create_table :surveys do |t|
      t.belongs_to :user, index: true
      t.boolean :private, null: false, default: true
      t.boolean :anonymous, null: false, default: true
      t.string :title, null: false
      t.string :passcode, null: false
      t.date :active_until, null: false
      t.timestamps
    end
  end
end
