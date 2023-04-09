class AddStudentRecordAndTeacherRecordToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_reference :users, :teacher, foreign_key: true, index: true
    add_reference :users, :student, foreign_key: true, index: true
  end
end
