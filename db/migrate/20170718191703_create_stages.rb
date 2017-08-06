class CreateStages < ActiveRecord::Migration[5.1]
  def change
    create_table :stages do |t|
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.timestamps
    end
  end
end
