FactoryBot.define do
  factory :faculty do
    name { Faker::Educator.university }
    aliases { [] }
  end
end
