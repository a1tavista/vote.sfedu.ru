FactoryBot.define do
  factory :faculty do
    name { Faker::Educator.university }
  end
end
