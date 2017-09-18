class Student < ApplicationRecord
  has_one :user, as: :kind, dependent: :destroy
  has_many :grade_books, dependent: :destroy
  has_many :students_teachers_relations, dependent: :destroy
  has_many :participations, dependent: :destroy

  after_create :load_personal_information!

  def load_personal_information!
    student = Soap::StudentPersonal.all_info(external_id)
    update(name: student[:name])
    # student[:study_info].each do |info|
    #   grade_books << GradeBook.create(info)
    # end
  end

  def all_teachers(stage)
    return [] if stage.nil?
    Teacher.
      select('"teachers"."id"', '"teachers"."name"').
      distinct.
      joins('INNER JOIN "students_teachers_relations" ON "teachers"."id" = "students_teachers_relations"."teacher_id"').
      joins('INNER JOIN "semesters_stages" ON "students_teachers_relations"."semester_id" = "semesters_stages"."semester_id"').
      joins('INNER JOIN "stages" ON "stages"."id" = "semesters_stages"."stage_id"').
      where('"stages"."id" = ?', stage.id).
      where('"students_teachers_relations"."student_id" = ?', id).
      order('"teachers"."name" ASC')
  end

  def evaluated_teachers(stage)
    return [] if stage.nil?
    all_teachers(stage)
      .joins("INNER JOIN \"participations\"
              ON \"teachers\".\"id\" = \"participations\".\"teacher_id\"
              AND \"participations\".\"stage_id\" = #{stage.id}
              AND \"participations\".\"student_id\" = #{id}")
  end

  def available_teachers(stage)
    return [] if stage.nil?
    all_teachers(stage)
      .joins("LEFT JOIN \"participations\"
              ON \"teachers\".\"id\" = \"participations\".\"teacher_id\"
              AND \"participations\".\"stage_id\" = #{stage.id}
              AND \"participations\".\"student_id\" = #{id}")
      .where(participations: { student_id: nil })
  end

  def teachers_load_required?
    students_teachers_relations.empty?
  end

  def load_teachers!
    ActiveRecord::Base.transaction do
      StudentsTeachersRelation.where(student: self).destroy_all
      student_teachers = Soap::StudentTeachers.all_info(external_id)

      student_teachers.each do |record|
        teacher = Teacher.find_or_create_by!(external_id: record[:external_id]) do |t|
          t.name = record[:name]
          t.snils = record[:snils]
        end
        create_relations!(teacher, record[:relations])
      end
    end
    true
  end

  private

  def create_relations!(teacher, relations)
    result = []
    relations.each do |r|
      semester = Semester.where(
        year_begin: r[:year_begin],
        year_end: r[:year_end],
        kind: r[:semester],
      ).first
      result << StudentsTeachersRelation.create!(
        student: self,
        teacher: teacher,
        semester: semester,
        disciplines: r[:disc_name],
      )
    end
    result
  end
end
