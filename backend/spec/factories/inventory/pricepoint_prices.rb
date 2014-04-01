FactoryGirl.define do
  factory :pricepoint_price do
    amount { rand(50) }
    currency { build [:usd, :eur, :gbp].sample }
    pricepoint { build :pricepoint }

    trait :usd do
      currency { build :usd }
    end

    trait :eur do
      currency { build :eur }
    end

    trait :gbp do
      currency { build :gbp }
    end
  end
end