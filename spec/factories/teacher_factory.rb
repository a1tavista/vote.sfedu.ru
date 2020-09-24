FactoryBot.define do
  factory :teacher do
    external_id { Faker::Russian.snils }
    name { Faker::Name.name }
    snils { Faker::Russian.snils }
    enabled { true }
    kind { :common }

    after(:create) do |teacher|
      teacher.encrypt_snils!
      teacher.reload
    end
  end
end
