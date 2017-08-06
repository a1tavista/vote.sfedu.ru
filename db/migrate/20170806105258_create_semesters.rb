class CreateSemesters < ActiveRecord::Migration[5.1]
  def change
    create_table :semesters do |t|
      t.integer :year_begin
      t.integer :year_end
      t.integer :kind
      t.timestamps
    end
  end
end
