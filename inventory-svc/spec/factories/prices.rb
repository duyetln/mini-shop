FactoryGirl.define do
  factory :price do
    name { SecureRandom.hex }
    pricepoint { FactoryGirl.create :pricepoint } 

    trait :discounted do
      discount { FactoryGir.create :discount_random }
    end
  end
end