class PersonalDataWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false

  def perform(student_id)
    Student.find_by_id(student_id)&.load_personal_information!
  end
end
