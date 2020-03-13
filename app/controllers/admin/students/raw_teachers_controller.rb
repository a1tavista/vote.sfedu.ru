module Admin
  module Students
    class RawTeachersController < BaseController
      def index
        @student = Student.find(params[:student_id])
        @teachers_data ||= teachers_from_soap
      end

      private

      def teachers_from_soap
        Soap::StudentTeachers.all_info(@student.external_id).map do |teacher|
          teacher.merge(record: Teachers::AsStudent::FindOrInitializeTeacher.run(raw_teacher: teacher).result)
        end
      end
    end
  end
end
