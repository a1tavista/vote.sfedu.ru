class Student < ApplicationRecord
  has_one :user, as: :kind, dependent: :destroy
  has_many :grade_books, dependent: :destroy
  has_many :faculties, through: :grade_books
  has_many :students_teachers_relations, dependent: :destroy
  has_many :teachers, through: :students_teachers_relations
  has_many :participations, dependent: :destroy
  has_many :stage_attendees, dependent: :destroy

  after_create { publish_event(Events::RegisteredNewStudent) }

  def teachers_chosen?(stage)
    stage_attendees.find_or_create_by(stage: stage).choosing_selected?
  end

  def self.without_grade_books
    select("students.id, students.name, students.external_id, count(grade_books.student_id) AS gb_count").
      joins('LEFT JOIN "grade_books" ON "grade_books"."student_id" = "students"."id"').
      group("students.id").
      having("count(grade_books.student_id) = 0")
      .order("students.name ASC")
  end

  def publish_event(klass, data = {})
    data = data.merge(student_id: id)
    event = klass.new(data: data)
    event_store.publish(event, stream_name: stream_name)
  end

  def stream_name
    ["Student", id].join(":")
  end

  def relations_by_semesters
    students_by_semesters = students_teachers_relations.group(:semester_id).order(:semester_id).count
    semesters = Semester.all.index_by(&:id)
    current_stage = Stage.current
    students_by_semesters.map do |k, v|
      {
        semester: semesters[k].full_title.capitalize,
        is_current: current_stage&.semester_ids&.include?(k) || false,
        count: v
      }
    end
  end
end
