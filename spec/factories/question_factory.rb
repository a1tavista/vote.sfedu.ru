FactoryBot.define do
  factory :question do
    text { Faker::Lorem.sentence }
    max_rating { 10 }
  end
end
