FactoryGirl.define do
  factory :price do
    name { SecureRandom.hex }
    pricepoint { FactoryGirl.create :pricepoint } 

    trait :discounted do
      discount { FactoryGirl.create :discount, :random }
    end
  end
end