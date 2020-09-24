FactoryBot.define do
  factory :stage do
    starts_at { Time.current - 1.week }
    ends_at { Time.current + 1.week }
    lower_participants_limit { 0 }
    scale_min { 6 }
    scale_max { 10 }
    lower_truncation_percent { 5 }
    upper_truncation_percent { 5 }
    with_scale { false }
    with_truncation { false }

    trait :with_questions do
      transient do
        questions_count { 5 }
      end

      after(:create) do |stage, evaluator|
        stage.questions << build_list(:question, evaluator.questions_count)
        stage.reload
      end
    end

    trait :with_semester do
      after(:create) do |stage, _|
        stage.semesters << build(:semester)
        stage.reload
      end
    end
  end
end
