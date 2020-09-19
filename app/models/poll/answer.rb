class Poll
  class Answer < ApplicationRecord
    self.table_name = "poll_answers"

    belongs_to :poll
    belongs_to :poll_option, class_name: "Poll::Option"
  end
end
