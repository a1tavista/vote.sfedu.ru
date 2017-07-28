class CreateGradeBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :grade_books do |t|
      t.belongs_to :student, index: true, foreign_key: true
      t.belongs_to :faculty, index: true, foreign_key: true
      t.string :major, null: false
      t.string :external_id, null: false
      t.integer :grade_num, null: false
      t.string :group_num, null: false
      t.integer :time_type, null: false, default: 0
      t.integer :grade_level, null: false, default: 0
      t.timestamps
    end
  end
end
