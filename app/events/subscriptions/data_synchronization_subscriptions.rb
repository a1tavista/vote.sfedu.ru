module Subscriptions
  class DataSynchronizationSubscriptions
    def self.subscribe(event_store)
      event_store.subscribe(
        Handlers::DataSynchronizationHandlers::GetPersonalInfo,
        to: [Events::UserAuthenticated]
      )

      event_store.subscribe(
        Handlers::DataSynchronizationHandlers::LoadTeachers,
        to: [Events::StudentRequestedTeachers]
      )
    end
  end
end
