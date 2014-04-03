FactoryGirl.define do
  factory :purchase do
    user { build :user }
    payment_method { build :payment_method, user: user }
    billing_address { build :address, user: user }
    shipping_address { build :address, user: user }

    trait :orders do
      after :build do |purchase|
        purchase.orders << build(:order)
      end
    end
  end
end
