class EventStore
  def initialize; end

  def setup
    [
      Subscriptions::DataSynchronizationSubscriptions
    ].each { |klass| klass.subscribe(event_store) }

    event_store.subscribe_to_all_events(RailsEventStore::LinkByCausationId.new(event_store: event_store))

    event_store
  end

  protected

  def event_store
    @event_store ||= RailsEventStore::Client.new(
      dispatcher: RubyEventStore::ComposedDispatcher.new(
        RailsEventStore::AfterCommitAsyncDispatcher.new(scheduler: CustomEventScheduler.new),
        RubyEventStore::PubSub::Dispatcher.new
      )
    )
  end
end
