class AddAliasesToFaculties < ActiveRecord::Migration[5.2]
  def change
    add_column :faculties, :aliases, :jsonb
  end
end
