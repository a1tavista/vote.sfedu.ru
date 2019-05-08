class AddChoosenForRelations < ActiveRecord::Migration[5.1]
  def change
    add_column :students_teachers_relations, :choosen, :boolean, null: false, default: false
  end
end
