module DataSynchronizationHandlers
  class LoadTeachers < BaseHandler
    prepend AsyncHandler
    sidekiq_options queue: :event_queue, retry: true

    def perform(event)
      student = Student.find(event.data[:student_id])
      Teachers::AsStudent::FetchFromDataSource.run(student: student)
    end
  end
end
