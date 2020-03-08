module Subscriptions
  class DataSynchronizationSubscriptions
    def self.subscribe(event_store)
      event_store.subscribe(
        DataSynchronizationHandlers::GetPersonalInfo,
        to: [
          Events::RegisteredNewUser,
          Events::UserAuthenticated
        ]
      )

      event_store.subscribe(DataSynchronizationHandlers::LoadTeachers, to: [Events::StudentRequestedTeachers])
    end
  end
end
