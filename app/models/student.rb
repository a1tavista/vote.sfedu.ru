class Student < ApplicationRecord
  has_one :user, as: :kind, dependent: :destroy
  has_many :grade_books, dependent: :destroy
  has_many :students_teachers_relations, dependent: :destroy
  has_many :teachers, through: :students_teachers_relations
  has_many :participations, dependent: :destroy

  after_create :load_personal_information!

  def teachers_loaded?
    teachers.any?
  end

  def load_personal_information!
    student = Soap::StudentPersonal.all_info(external_id)
    update(name: student[:name])
    student[:study_info].each do |info|
      grade_books << GradeBook.create(info)
    end
  rescue => e
    Raven.capture_exception(e)
    raise e
  end

  def drop_teachers_relations!
    students_teachers_relations.destroy_all
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
    all_teachers(stage).
      joins("INNER JOIN \"participations\"
              ON \"teachers\".\"id\" = \"participations\".\"teacher_id\"
              AND \"participations\".\"stage_id\" = #{stage.id}
              AND \"participations\".\"student_id\" = #{id}")
  end

  def available_teachers(stage)
    return [] if stage.nil?
    all_teachers(stage).
      joins("LEFT JOIN \"participations\"
              ON \"teachers\".\"id\" = \"participations\".\"teacher_id\"
              AND \"participations\".\"stage_id\" = #{stage.id}
              AND \"participations\".\"student_id\" = #{id}").
      where(participations: { student_id: nil })
  end

  def teachers_load_required?
    students_teachers_relations.empty?
  end

  def load_teachers!
    ActiveRecord::Base.transaction do

      StudentsTeachersRelation.where(student: self).destroy_all

      student_teachers = Soap::StudentTeachers.all_info(external_id)

      student_teachers.each do |record|
        next if record[:name].nil?

        teacher_external_id = Teacher.calculate_encrypted_snils(record[:snils])

        if teacher_external_id.nil?
          msg = "[SOAP] There is an invalid teacher without SNILS ID: #{record[:external_id]}"
          Raven.capture_message(msg)

          # There you can place the logic for matching fired teachers with existed teachers
          next # Instead of this!
        end

        # Получаем hash СНИЛСа


        # Создаем преподавателя
        teacher = Teacher.find_or_create_by(encrypted_snils: teacher_external_id) do |t|
          t.name = record[:name]
          t.snils = Teacher.clear_snils(record[:snils])
        end

        if teacher.persisted?
          teacher.update(external_id: record[:external_id])

          # Создаем связи между студентом и преподавателем
          create_relations!(teacher, record[:relations])
        else
          msg = "[SOAP] There is an invalid teacher with SNILS but without some stuff: #{record[:external_id]}"
          Raven.capture_message(msg)
        end
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
