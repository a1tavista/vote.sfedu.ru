class StageAttendee < ApplicationRecord
  belongs_to :student
  belongs_to :stage

  enum fetching_status: [:fresh, :in_progress, :done, :failed], _prefix: :fetching
  enum choosing_status: [:not_selected, :selected, :skipped], _prefix: :choosing
end
