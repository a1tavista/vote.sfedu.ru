class CreateStageAttendees < ActiveRecord::Migration[5.1]
  def change
    create_table :stage_attendees do |t|
      t.belongs_to :student, foreign_key: true
      t.belongs_to :stage, foreign_key: true
      t.integer :choosing_status, null: false, default: 0
      t.integer :fetching_status, null: false, default: 0

      t.timestamps
    end
  end
end
