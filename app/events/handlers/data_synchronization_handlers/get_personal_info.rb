module Handlers
  module DataSynchronizationHandlers
    class GetPersonalInfo < BaseHandler
      def handle_event
        user = User.find(event.data[:user_id])
        Students::Operations::FillPersonalInfo.new.call(student: user.kind) if user.student?
      end
    end
  end
end
