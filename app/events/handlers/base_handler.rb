module Handlers
  class BaseHandler
    include Sidekiq::Worker

    attr_reader :event

    sidekiq_options queue: :event_queue, retry: false

    def perform(payload)
      @event = Rails.configuration.event_store.deserialize(payload.transform_keys(&:to_sym))

      set_raven_context
      handle_event
    rescue NotImplementedError
      Rails.logger.fatal "#{self.class} is not implemented yet"
    end

    def self.with_event_id(event_id)
      event = Rails.configuration.event_store.read.event(event_id)
      serialized_event = RubyEventStore::Mappers::Default.new.event_to_serialized_record(event)

      yield(self, serialized_event.to_h)
    end

    private

    def event_store
      Rails.configuration.event_store
    end

    def set_raven_context
      serialized_event = RubyEventStore::Mappers::Default.new.event_to_serialized_record(event)

      Raven.tags_context(dispatcher: self.class.to_s, event_type: event.event_type)
      Raven.extra_context(event: serialized_event.to_h)
    end
  end
end
