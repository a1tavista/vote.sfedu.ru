FactoryBot.define do
  factory :poll do
    name { 'Выборы председателя студенческого совета' }
    starts_at { Time.current - 1.week }
    ends_at { Time.current + 1.week }

    trait :with_options do
      transient do
        options_count { 5 }
      end

      after(:create) do |poll, evaluator|
        create_list(:poll_option, evaluator.options_count, poll: poll)
        poll.reload
      end
    end
  end
end
