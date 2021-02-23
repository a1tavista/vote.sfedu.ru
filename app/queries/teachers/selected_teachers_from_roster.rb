module Teachers
  class SelectedTeachersFromRoster
    extend Dry::Initializer

    option :student
    option :stage

    def call
      all_teachers.joins(join_condition).merge(StudentsTeachersRelation.where(student_id: student.id))
    end

    private

    def join_condition
      <<-SQL.squish
        INNER JOIN "students_teachers_relations"
        ON "teachers"."id" = "students_teachers_relations"."teacher_id"
        AND "students_teachers_relations"."student_id" = #{student.id}
        AND "students_teachers_relations"."stage_id" = #{stage.id}
        AND "students_teachers_relations"."origin" = 'roster'
      SQL
    end

    def all_teachers
      AllTeachersFromRoster.new(stage: stage).call
    end
  end
end
