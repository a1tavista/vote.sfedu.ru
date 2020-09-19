class Poll
  class Participation < ApplicationRecord
    self.table_name = 'poll_participations'

    belongs_to :poll
  end
end
