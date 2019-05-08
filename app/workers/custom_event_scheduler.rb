class CustomEventScheduler
  def call(klass, serialized_event)
    klass.perform_async(serialized_event.to_h.transform_keys(&:to_sym))
  end

  # method which is checking whether given subscriber is correct for this scheduler
  def verify(subscriber)
    subscriber.is_a?(Class) && subscriber.respond_to?(:perform_async)
  end
end
