class AddAliasesToFaculties < ActiveRecord::Migration[5.2]
  def change
    add_column :faculties, :aliases, :text, array: true, default: []
  end
end
