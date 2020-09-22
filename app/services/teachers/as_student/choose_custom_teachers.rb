module Teachers
  module AsStudent
    class ChooseCustomTeachers < BaseInteraction
      record :student
      array :lang_teacher_ids, default: []
      array :physical_teacher_ids, default: []
      array :selected_teacher_ids, default: -> { lang_teacher_ids + physical_teacher_ids }

      def execute
        ActiveRecord::Base.transaction do
          # Step 1: Remove old relations between student and teacher
          student.students_teachers_relations.where(choosen: true).delete_all

          # Step 2: Add relations between student and teacher
          semester = Stage.current.semesters.first # HACK: semester_id is required field
          selected_teacher_ids.each do |id|
            student.students_teachers_relations.create(teacher_id: id, semester: semester, choosen: true)
          end

          stage_attendee.update(choosing_status: :selected)
          student.publish_event(Events::StudentRequestedTeachers)
        end
      end

      def stage_attendee
        @stage_attendee ||= StageAttendee.find_or_initialize_by(student: student, stage: Stage.current)
      end
    end
  end
end
