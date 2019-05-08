class AddIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :students, :external_id
    add_index :teachers, :external_id
  end
end
