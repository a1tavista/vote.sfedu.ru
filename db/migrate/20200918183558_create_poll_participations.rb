class CreatePollParticipations < ActiveRecord::Migration[5.2]
  def change
    create_table :poll_participations, index: :uuid do |t|
      t.belongs_to :poll, index: true, foreign_key: true
      t.belongs_to :student, index: true, foreign_key: true
    end
  end
end
