module Teachers
  class EvaluatedTeachersForStudent
    extend Dry::Initializer

    option :student
    option :stage

    def call
      all_teachers.joins(join_condition)
    end

    private

    def join_condition
      "LEFT JOIN \"participations\"
              ON \"teachers\".\"id\" = \"participations\".\"teacher_id\"
              AND \"participations\".\"stage_id\" = #{stage.id}
              AND \"participations\".\"student_id\" = #{student.id}"
    end

    def all_teachers
      AllTeachersForStudent.new(student: student, stage: stage).call
    end
  end
end
