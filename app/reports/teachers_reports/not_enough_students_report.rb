module TeachersReports
  class NotEnoughStudentsReport
    def initialize(stage)
      @stage = stage
      @teachers = Teacher.
        select("teachers.id, teachers.name, count(students_teachers_relations.student_id) AS students_count").
        joins("LEFT JOIN \"students_teachers_relations\" ON \"students_teachers_relations\".\"teacher_id\" = \"teachers\".\"id\" AND \"students_teachers_relations\".\"semester_id\" IN (#{stage.semester_ids.join(", ")})").
        group("teachers.id").
        having("count(students_teachers_relations.student_id) < 10").
        order("teachers.name ASC")
    end

    def paginate(page: 1, per: 20)
      @current_page = page
      @teachers = @teachers.page(page).per(per)
      self
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
        source: @teachers
      )
    end
  end
end
