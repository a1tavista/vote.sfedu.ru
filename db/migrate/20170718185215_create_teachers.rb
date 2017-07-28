class CreateTeachers < ActiveRecord::Migration[5.1]
  def change
    create_table :teachers do |t|
      t.string :external_id, null: false
      t.boolean :enabled, default: true
      t.timestamps
    end
  end
end
