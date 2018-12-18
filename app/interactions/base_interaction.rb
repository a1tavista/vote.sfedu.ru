class BaseInteraction < ActiveInteraction::Base
  include MergeNestedErrors

  protected

  def event_store
    Rails.configuration.event_store
  end
end
