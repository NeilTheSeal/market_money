FactoryBot.define do
  factory :vehicle do
    make { Faker::Vehicle.make }
    model { Faker::Vehicle.model }
    year { Faker::Vehicle.year }
  end
end
