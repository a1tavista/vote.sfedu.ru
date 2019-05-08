module AsyncHandler
  def perform(payload)
    event = Rails.configuration.event_store.deserialize(payload.transform_keys(&:to_sym))

    Raven.tags_context(dispatcher: self.class.to_s, event_type: event.type)
    Raven.extra_context(event: event.to_h)

    super(event)
  rescue NotImplementedError
    Rails.logger.fatal "#{self.class} is not implemented yet"
  end
end
