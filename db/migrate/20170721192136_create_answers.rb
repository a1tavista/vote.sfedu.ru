class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.belongs_to :question, index: true, foreign_key: true
      t.belongs_to :stage, index: true, foreign_key: true
      t.belongs_to :teacher, index: true, foreign_key: true
      t.integer :ratings, array: true # Количество ответов по
      t.timestamps
    end

    add_index :answers, :ratings, using: 'gin'
  end
end
