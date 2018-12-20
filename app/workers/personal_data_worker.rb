class PersonalDataWorker
  include Sidekiq::Worker

  def perform(student_id)
    Student.find_by_id(student_id)&.load_personal_information!
  end
end
