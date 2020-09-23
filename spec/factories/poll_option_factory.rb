FactoryBot.define do
  factory :poll_option, class: 'Poll::Option' do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end
end
