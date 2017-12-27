module TeachersReports
  class NotEnoughParticipationsReport
    def initialize(stage)
      @stage = stage
      @teachers = Teacher.
        select('teachers.id, teachers.name, count(participations.student_id) AS students_count').
        joins("LEFT JOIN \"participations\" ON \"participations\".\"teacher_id\" = \"teachers\".\"id\" AND \"participations\".\"stage_id\" = #{stage.id}").
        group('teachers.id').
        having('count(participations.student_id) < 10').
        order('teachers.name ASC')
    end

    def paginate(page: 1, per: 20)
      @teachers = @teachers.page(page).per(per)
      self
    end


    def summary
      [
        {
          label: 'Всего преподавателей в списке:',
          count: @teachers.count,
        }
      ]
    end

    def build
      result = []

      @teachers.each do |row|
        result << {
          teacher: row,
          count: row.students_count,
          lack: @stage.lower_participants_limit - row.students_count
        }
      end

      OpenStruct.new(
        rows: result,
        source: @teachers,
      )
    end
  end
end
