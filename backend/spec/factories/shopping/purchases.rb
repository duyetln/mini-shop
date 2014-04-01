FactoryGirl.define do
  factory :purchase do
    user { build :user }
    payment_method { build :payment_method }
    billing_address { build :address }
    shipping_address { build :address }

    trait :orders do
      after :build do |purchase|
        purchase.orders << build(:order)
      end
    end
  end
end
