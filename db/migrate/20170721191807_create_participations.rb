class CreateParticipations < ActiveRecord::Migration[5.1]
  def change
    create_table :participations do |t|
      t.belongs_to :stage, index: true, foreign_key: true
      t.belongs_to :student, index: true, foreign_key: true
      t.belongs_to :teacher, index: true, foreign_key: true
      t.timestamps
    end
  end
end
