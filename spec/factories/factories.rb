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

  factory :vendor do
    name { Faker::FunnyName.name }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { true }
  end
end
