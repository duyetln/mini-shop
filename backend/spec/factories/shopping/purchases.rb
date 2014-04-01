FactoryGirl.define do
  factory :purchase do
    user { build :user }

    trait :ready do
      payment_method { build :payment_method }
      billing_address { build :address }
      shipping_address { build :address }
    end
  end
end
