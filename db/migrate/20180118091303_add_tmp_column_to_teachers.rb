class AddTmpColumnToTeachers < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :encrypted_snils, :string
    change_column :teachers, :external_id, :string, null: true
  end
end
