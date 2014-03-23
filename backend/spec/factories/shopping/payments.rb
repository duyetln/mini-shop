FactoryGirl.define do
  factory :payment do
    payment_method { create :payment_method }
    user { payment_method.user }
    amount { 100 }
    currency { payment_method.currency }
    billing_address { create :address }
  end
end
