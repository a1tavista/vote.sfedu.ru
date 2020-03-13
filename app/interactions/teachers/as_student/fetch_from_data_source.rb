module Teachers
  module AsStudent
    class FetchFromDataSource < BaseInteraction
      record :student

      def execute
        drop_old_relations

        teachers_data.each do |raw|
          next log_broken_data_for_teacher(raw) if raw[:name].blank?

          # Шаг 1. Готовим SHA1(СНИЛС)
          teacher = Teachers::AsStudent::FindOrInitializeTeacher.run(raw_teacher: raw).result
          next log_broken_data_for_teacher(raw) if teacher.nil?
          success = teacher.update(name: raw[:name], external_id: raw[:external_id])

          next log_incorrect_teacher(teacher) unless success

          add_relations_with_teacher!(teacher, raw[:relations])
        end

        stage_attendee.update(fetching_status: :done) if teachers_data.any?
      end

      private

      def teachers_data
        @teachers_data ||= Soap::StudentTeachers.all_info(student.external_id)
      rescue StandardError => e
        stage_attendee.update(fetching_status: :failed)
        raise e
      end

      def stage_attendee
        @stage_attendee ||= StageAttendee.find_or_initialize_by(student: student, stage: Stage.current)
      end

      def log_broken_data_for_teacher(record)
        # TODO: log somewhere
      end

      def log_incorrect_teacher(teacher)
        event = Events::ReceivedInvalidTeacher.new(data: teacher.attributes)
        event_store.append(event)
      end

      def add_relations_with_teacher!(teacher, relations)
        result = []

        relations.each do |relation|
          result << StudentsTeachersRelation.create!(
            student: student,
            teacher: teacher,
            disciplines: relation[:disc_name],
            semester: Semester.find_by(
              year_begin: relation[:year_begin],
              year_end: relation[:year_end],
              kind: relation[:kind]
            )
          )
        end

        result
      end

      def drop_old_relations
        student.students_teachers_relations.where(choosen: false).delete_all
      end
    end
  end
end
