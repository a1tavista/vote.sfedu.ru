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
        create(:grade_book, student: student, faculty: Faculty.find(evaluator.faculty_id))
        student.reload
      end
    end
  end
end
