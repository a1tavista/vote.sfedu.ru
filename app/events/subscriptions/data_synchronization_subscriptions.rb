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
    end
  end
end
