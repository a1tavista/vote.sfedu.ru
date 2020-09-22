module Teachers
  module AsStudent
    class ResetTeachersList < BaseInteraction
      record :student

      def execute
        stage_attendee.update(fetching_status: :in_progress)
        student.publish_event(Events::StudentRequestedTeachers)
      end

      private

      def stage_attendee
        @stage_attendee ||= StageAttendee.find_or_initialize_by(student: student, stage: Stage.current)
      end
    end
  end
end
