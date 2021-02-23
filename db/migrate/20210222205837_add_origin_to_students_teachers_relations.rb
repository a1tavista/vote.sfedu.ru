class AddOriginToStudentsTeachersRelations < ActiveRecord::Migration[5.2]
  def change
    add_column :students_teachers_relations, :origin, :string, index: true
  end
end
