module Handlers
  module DataSynchronizationHandlers
    class LoadTeachers < BaseHandler
      def handle_event
        student = Student.find(event.data[:student_id])
        Teachers::AsStudent::FetchFromDataSource.run(student: student)
      end
    end
  end
end
