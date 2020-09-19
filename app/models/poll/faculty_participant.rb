class Poll
  class FacultyParticipant < ApplicationRecord
    self.table_name = 'poll_faculty_participants'

    belongs_to :poll
    belongs_to :faculty
  end
end
