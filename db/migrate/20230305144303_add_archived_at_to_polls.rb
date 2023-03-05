class AddArchivedAtToPolls < ActiveRecord::Migration[5.2]
  def change
    add_column :polls, :archived_at, :datetime
  end
end
