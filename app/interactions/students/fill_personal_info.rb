module Students
  class FillPersonalInfo < BaseInteraction
    record :student
    object :personal_data,
           class: :object,
           default: -> { Soap::StudentPersonal.all_info(student.external_id) }

    def execute
      student.update(name: personal_data[:name])

      personal_data[:study_info].each do |info|
        grade_book = GradeBook.find_or_initialize_by(external_id: info[:external_id])
        grade_book.assign_attributes(info)
        grade_book.student_id = student.id
        grade_book.save
      end
    end
  end
end
