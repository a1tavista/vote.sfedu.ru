class CreateStudentsTeachersRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :students_teachers_relations do |t|
      t.belongs_to :student, index: true, foreign_key: true
      t.belongs_to :teacher, index: true, foreign_key: true
      t.belongs_to :semester, index: true, foreign_key: true
      t.string :disciplines, array: true
      t.timestamps
    end
  end
end
