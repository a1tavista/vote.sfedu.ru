module Teachers
  module AsStudent
    class FetchFromDataSource < BaseInteraction
      record :student
      array :teachers_data, default: -> { Soap::StudentTeachers.all_info(student.external_id) }

      boolean :safe, default: true, desc: 'Interrupts if there already '

      def execute
        ActiveRecord::Base.transaction do
          drop_old_relations

          teachers_data.each do |record|
            next if record[:name].presence.nil?

            clean_snils = Snils.normalize(record[:snils])
            teacher_external_id = Snils.encrypt(clean_snils)

            if teacher_external_id.nil?
              notify_admin_with(
                msg: '[SOAP] Invalid teacher record',
                teacher_external_id: record[:external_id]
              )
              teacher = Teacher.find_by(stale_external_id: record[:external_id])
            end

            teacher ||= Teacher.find_or_create_by(encrypted_snils: teacher_external_id) do |t|
              t.name = record[:name]
              t.snils = clean_snils
            end

            unless teacher.persisted?
              notify_admin_with(
                msg: '[SOAP] Teacher is not created',
                teacher_external_id: record[:external_id]
              )
              next
            end

            # У преподавателя мог смениться ID в базе данных преподавателей, поэтому обновляем
            teacher.update(external_id: record[:external_id])
            add_relations_with_teacher!(teacher, record[:relations])
          end
        end
      end

      private

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

      def notify_admin_with(msg:, teacher_external_id:)
        exception_data = {
          level: 'info',
          extra: {
            'teacher_external_id': teacher_external_id,
            'student_external_id': student.external_id,
          },
          tags: {
            'student_id': student.id
          },
          fingerprint: ['invalid_teacher', 'invalid_teacher_snils'],
        }

        Raven.capture_message(msg, exception_data)
        true
      end
    end
  end
end
