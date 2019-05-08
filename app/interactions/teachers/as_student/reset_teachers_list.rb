module Teachers
  module AsStudent
    class ResetTeachersList < BaseInteraction
      record :student

      def execute
        student.students_teachers_relations.where(choosen: false).delete_all
        FetchFromDataSource.run(student: student)
      end
    end
  end
end
