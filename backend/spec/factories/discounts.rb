FactoryGirl.define do
  factory :discount_none, class: Discount do
    name { SecureRandom.hex } 
    rate 0.0
  end

  factory :discount_half, class: Discount do
    name { SecureRandom.hex }
    rate 0.5
  end

  factory :discount_random, class: Discount do
    name { SecureRandom.hex }
    rate { rand(50) / 100.0 }
  end
end