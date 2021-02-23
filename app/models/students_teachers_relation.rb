class StudentsTeachersRelation < ApplicationRecord
  belongs_to :student
  belongs_to :teacher

  belongs_to :semester, optional: true
  belongs_to :stage, optional: true

  enum origin: {
    database: "database",
    roster: "roster",
    support: "support"
  }, _prefix: :from
end
