FactoryGirl.define do
  factory :discount, class: Discount do
  name { SecureRandom.hex }

    trait :none do
      rate 0.0
    end

    trait :half do
      rate 0.5
    end

    trait :random do
      rate { rand(50) / 100.0 }
    end

    trait :past do
      end_at { 5.days.ago }
    end

    trait :present do
      start_at { 5.days.ago }
      end_at { 5.days.from_now }
    end

    trait :future do
      start_at { 5.days.from_now }
    end
  end
end