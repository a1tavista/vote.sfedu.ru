class Poll
  class Option < ApplicationRecord
    self.table_name = "poll_options"

    belongs_to :poll
  end
end
