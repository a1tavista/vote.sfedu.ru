FactoryBot.define do
  factory :grade_book do
    student
    faculty
    major { Faker::Educator.subject }
    external_id { Faker::IDNumber.valid }
    grade_num { Faker::Number.between(from: 1, to: 2) }
    group_num { Faker::Educator.degree }
    time_type { :fulltime }
    grade_level { :specialist }
  end
end
