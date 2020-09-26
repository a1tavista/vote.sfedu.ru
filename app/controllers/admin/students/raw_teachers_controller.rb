module Admin
  module Students
    class RawTeachersController < BaseController
      def index
        @student = Student.find(params[:student_id])
        @teachers_data ||= teachers_from_soap
      end

      private

      def teachers_from_soap
        OneCApi::FetchStudentTeachersRelations.new.call(external_id: @student.external_id).map do |raw_teacher|
          teacher = Teachers::Operations::FindOrInitializeTeacher.run(raw_teacher: raw_teacher).result
          teacher.validate
          raw_teacher.merge(record: teacher, errors: teacher.errors.full_messages)
        end
      end
    end
  end
end
