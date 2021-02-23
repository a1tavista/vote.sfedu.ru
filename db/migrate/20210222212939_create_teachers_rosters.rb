class CreateTeachersRosters < ActiveRecord::Migration[5.2]
  def change
    create_table :teachers_rosters do |t|
      t.belongs_to :stage, index: true
      t.belongs_to :teacher
      t.string :kind, index: true
      t.timestamps
    end
  end
end
