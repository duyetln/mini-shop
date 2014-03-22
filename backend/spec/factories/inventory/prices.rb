FactoryGirl.define do
  factory :price do
    name { SecureRandom.hex }
    association :pricepoint

    trait :discounted do
      association :discount, :random
    end
  end
end