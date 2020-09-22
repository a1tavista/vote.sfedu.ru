FactoryBot.define do
  factory :student do
    external_id { Faker::Russian.snils }
    name { Faker::Name.name }
    enabled { true }
  end
end
