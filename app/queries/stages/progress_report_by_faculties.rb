module Stages
  class ProgressReportByFaculties
    include Dry::Transaction::Operation

    def call(stage:)
      faculties_query_for(stage).index_by { |entity| entity[:faculty].id }
    end

    private

    def faculties_query_for(stage)
      Faculty.all.map do |faculty|
        students_count = faculty.participants(stage).count
        participations_count = faculty.participations_by_stage(stage).count
        per_student = 0 if students_count.zero?
        per_student ||= participations_count / students_count.to_f

        {
          faculty: faculty,
          students: students_count,
          participations: participations_count,
          participations_per_student: per_student
        }
      end
    end
  end
end
