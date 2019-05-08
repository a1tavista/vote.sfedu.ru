module DataSynchronizationHandlers
  class GetPersonalInfo < BaseHandler
    prepend AsyncHandler

    def perform(event)
      user = User.find(event.data[:user_id])
      Students::FillPersonalInfo.run(student: user.kind) if user.student?
    end
  end
end
