FactoryGirl.define do
  factory :price do
    name { SecureRandom.hex }
    pricepoint { create :pricepoint }

    trait :discounted do
      discount { create :discount, :random }
    end
  end
end