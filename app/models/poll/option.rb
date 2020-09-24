class Poll
  class Option < ApplicationRecord
    self.table_name = "poll_options"
    include ImageUploader::Attachment(:image)

    belongs_to :poll
  end
end
