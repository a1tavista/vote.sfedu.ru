module Teachers
  module AsStudent
    class FindOrInitializeTeacher < BaseInteraction
      hash :raw_teacher, strip: false

      def execute
        clean_snils = Snils.normalize(raw_teacher[:snils])
        teacher_external_id = Snils.encrypt(clean_snils)

        # Шаг 1. Ищем преподаватлея в базе по ID из 1С, если из 1С пришел пустой СНИЛС
        teacher = Teacher.find_by(stale_external_id: raw_teacher[:external_id]) if teacher_external_id.nil?

        # Шаг 2. Ищем или инициализируем преподавателя, если его ещё не было, и обновляем его данные из 1С
        teacher ||= Teacher.find_or_initialize_by(encrypted_snils: teacher_external_id) { |t| t.snils = clean_snils }

        #noinspection RubyUnnecessaryReturnValue
        teacher
      end
    end
  end
end
