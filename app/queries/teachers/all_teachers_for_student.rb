module Teachers
  class AllTeachersForStudent
    extend Dry::Initializer

    option :student
    option :stage

    def call
      return Teacher.none if stage.nil?

      Teacher.
        select('"teachers"."id"', '"teachers"."name"').
        distinct.
        joins('INNER JOIN "students_teachers_relations" ON "teachers"."id" = "students_teachers_relations"."teacher_id"').
        joins('INNER JOIN "semesters_stages" ON "students_teachers_relations"."semester_id" = "semesters_stages"."semester_id"').
        joins('INNER JOIN "stages" ON "stages"."id" = "semesters_stages"."stage_id"').
        where('"stages"."id" = ?', stage.id).
        where('"students_teachers_relations"."student_id" = ?', student.id).
        order('"teachers"."name" ASC')
    end
  end
end
