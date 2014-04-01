FactoryGirl.define do
  factory :payment do
    payment_method { build :payment_method }
    user { payment_method.user }
    amount { 100 }
    currency { payment_method.currency }
    billing_address { build :address }
  end
end
