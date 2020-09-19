class CreatePollFacultyParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :poll_faculty_participants do |t|
      t.belongs_to :poll, index: true, foreign_key: true
      t.belongs_to :faculty, index: true, foreign_key: true
    end
  end
end
