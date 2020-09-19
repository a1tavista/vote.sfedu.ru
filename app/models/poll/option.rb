class Poll
  class Option < ApplicationRecord
    self.table_name = 'poll_options'
  end
end
