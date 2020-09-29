module Faculties
  module AsAdmin
    class MergeDuplicatedFacultyToAnotherFaculty
      include Dry::Transaction

      class Contract < Dry::Validation::Contract
        params do
          required(:faculty).filled(type?: Faculty)
          required(:duplicated_faculty).filled(type?: Faculty)
        end
      end

      step :validate_input
      check :faculties_are_different
      step :merge_faculties
      step :destroy_duplicated_faculty

      def validate_input(input)
        ::Operations::ValidateInput.new.call(input, contract_klass: Contract)
      end

      def faculties_are_different(input)
        input[:faculty].id != input[:duplicated_faculty].id
      end

      def merge_faculties(faculty:, duplicated_faculty:)
        Poll::FacultyParticipant.where(faculty_id: duplicated_faculty.id).update_all(faculty_id: faculty.id)
        GradeBook.where(faculty: duplicated_faculty).update_all(faculty_id: faculty.id)

        faculty.aliases ||= []
        faculty.aliases << duplicated_faculty.name
        faculty.save ? Success(faculty: faculty, duplicated_faculty: duplicated_faculty) : Failure()
      end

      def destroy_duplicated_faculty(faculty:, duplicated_faculty:)
        duplicated_faculty.destroy

        Success(faculty: faculty)
      end
    end
  end
end
