class AddTeachersFlags < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :kind, :integer, default: 0
  end
end
