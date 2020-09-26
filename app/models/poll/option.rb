class Poll
  class Option < ApplicationRecord
    self.table_name = "poll_options"
    include ::ImageUploader::Attachment(:image)

    belongs_to :poll
    has_many :answers, class_name: 'Poll::Answer', foreign_key: 'poll_option_id'

    def proportion
      answers_by_poll = poll.answers.count

      return 0 if answers_by_poll

      answers.count / answers_by_poll
    end
  end
end
