class CreateStages < ActiveRecord::Migration[5.1]
  def change
    create_table :stages do |t|
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :lower_participants_limit, null: false, default: 10
      t.integer :scale_min, null: false, default: 6
      t.integer :scale_max, null: false, default: 10
      t.integer :lower_truncation_percent, null: false, default: 5
      t.integer :upper_truncation_percent, null: false, default: 5
      t.string :scale_ladder, array: true
      t.timestamps
    end
  end
end
