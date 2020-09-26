require 'dry/transaction/operation'

module Students
  module Operations
    class FillPersonalInfo
      include Dry::Transaction::Operation

      def call(student:, personal_data: nil)
        personal_data ||= personal_data_for(student)

        student.update(name: personal_data[:name])

        personal_data[:study_info].each do |info|
          grade_book = GradeBook.find_or_initialize_by(external_id: info[:external_id])
          grade_book.assign_attributes(info)
          grade_book.student_id = student.id
          grade_book.save
        end

        Success
      end

      private

      def personal_data_for(student)
        OneCApi::FetchStudentPersonalData.new.call(external_id: student.external_id)
      end
    end
  end
end
