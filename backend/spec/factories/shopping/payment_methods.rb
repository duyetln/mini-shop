FactoryGirl.define do
  factory :payment_method do
    name { Faker::Lorem.characters(10) }
    balance { 1_000_000 }
    user { create :user }
    currency { Currency.where(code: 'USD').first_or_create! }
  end
end
