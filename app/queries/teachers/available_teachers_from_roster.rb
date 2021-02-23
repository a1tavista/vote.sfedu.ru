module Teachers
  class AvailableTeachersFromRoster
    extend Dry::Initializer

    option :student
    option :stage

    def call
      all_teachers.joins(join_condition).merge(StudentsTeachersRelation.where(student_id: nil))
    end

    private

    def join_condition
      <<-SQL.squish
        LEFT JOIN "students_teachers_relations"
        ON "teachers"."id" = "students_teachers_relations"."teacher_id"
        AND "students_teachers_relations"."student_id" = #{student.id}
        AND (
          "students_teachers_relations"."stage_id" = #{stage.id}
          OR "students_teachers_relations"."semester_id" IN (#{stage.semester_ids.join(',')})
        )
      SQL
    end

    def all_teachers
      AllTeachersFromRoster.new(stage: stage).call
    end
  end
end
