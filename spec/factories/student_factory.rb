FactoryBot.define do
  factory :student do
    external_id { Faker::Russian.snils }
    name { Faker::Name.name }
    enabled { true }

    trait :with_grade_book do
      transient do
        faculty_id { nil }
      end

      after(:create) do |student, evaluator|
        grade_book = build(:grade_book, student: student)
        grade_book.faculty = Faculty.find(evaluator.faculty_id) if evaluator.faculty_id.present?
        grade_book.save
        student.reload
      end
    end
  end
end
