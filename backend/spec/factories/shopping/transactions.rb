FactoryGirl.define do
  factory :transaction do
    payment_method { build :payment_method }
    user { payment_method.user }
    amount { 100 }
    currency { payment_method.currency }
    billing_address { build :address, user: user }
  end
end
