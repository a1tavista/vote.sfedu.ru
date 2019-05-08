Rails.application.configure do
  config.to_prepare do
    Rails.configuration.event_store = EventStore.new.setup
  end
end
