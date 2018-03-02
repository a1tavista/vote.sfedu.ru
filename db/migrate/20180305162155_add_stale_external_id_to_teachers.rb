class AddStaleExternalIdToTeachers < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :stale_external_id, :string
  end
end
