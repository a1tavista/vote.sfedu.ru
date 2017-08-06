class CreateSemestersStages < ActiveRecord::Migration[5.1]
  def change
    create_table :semesters_stages do |t|
      t.belongs_to :semester, foreign_key: true
      t.belongs_to :stage, foreign_key: true
    end
  end
end
