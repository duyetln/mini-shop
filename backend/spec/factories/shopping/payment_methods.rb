FactoryGirl.define do
  factory :payment_method do
    name { Faker::Lorem.characters(10) }
    balance { 1_000_000 }
    user { build :user }
    currency { build :usd }
  end
end
