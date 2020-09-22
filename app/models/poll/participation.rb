class Poll
  class Participation < ApplicationRecord
    self.table_name = "poll_participations"

    belongs_to :poll
    belongs_to :student
  end
end
