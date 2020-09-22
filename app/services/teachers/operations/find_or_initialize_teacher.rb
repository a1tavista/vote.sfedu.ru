module Teachers
  module Operations
    class FindOrInitializeTeacher < BaseInteraction
      hash :raw_teacher, strip: false

      def execute
        clean_snils = Snils.normalize(raw_teacher[:snils])
        teacher_external_id = Snils.encrypt(clean_snils)

        # Вариант 1. Ищем или инициализируем преподаватлея в базе по ID из 1С, если из 1С пришел пустой СНИЛС
        return Teacher.find_or_initialize_by(stale_external_id: raw_teacher[:external_id]) if teacher_external_id.blank?

        # Вариант 2. Ищем или инициализируем преподавателя, если его ещё не было, и обновляем его данные из 1С
        Teacher.find_or_initialize_by(encrypted_snils: teacher_external_id) { |t| t.snils = clean_snils }
      end
    end
  end
end
