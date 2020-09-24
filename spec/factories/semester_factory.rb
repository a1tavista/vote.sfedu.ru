FactoryBot.define do
  factory :semester do
    year_begin { Date.current.year }
    year_end { Date.current.year + 1 }
    kind { :fall }
  end
end
