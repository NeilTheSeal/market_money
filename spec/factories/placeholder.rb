FactoryBot.define do
  factory :market do
    name { Faker::FunnyName.name }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Address.country }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { 37.740092 + rand(-0.25..0.25) }
    lon { -104.990308 + rand(-0.25..0.25) }
  end
end
