FactoryGirl.define do
  factory :price do
    name { SecureRandom.hex }
    pricepoint { build :pricepoint, :pricepoint_prices }

    trait :discounted do
      discount { build :discount, :random }
    end
  end
end
