FactoryGirl.define do
  factory :purchase do
    user { create :user }

    trait :ready do
      payment_method { create :payment_method }
      billing_address { create :address }
      shipping_address { create :address }
    end
  end
end