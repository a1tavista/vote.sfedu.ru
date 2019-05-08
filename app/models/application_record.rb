class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def event_store
    Rails.configuration.event_store
  end
end
