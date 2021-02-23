class AddStageIdToStudentsTeachersRelations < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :students_teachers_relations, :stage
  end
end
