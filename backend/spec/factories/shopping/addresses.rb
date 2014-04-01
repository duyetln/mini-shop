FactoryGirl.define do
  factory :address do
    line1 { Faker::Address.street_address }
    city { Faker::Address.city }
    region { Faker::Address.state }
    postal_code { Faker::Address.postcode }
    country { Faker::Address.country }
    user { build :user }
  end
end
