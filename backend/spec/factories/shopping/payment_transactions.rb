FactoryGirl.define do
  factory :payment_transaction do
    payment_method { build :payment_method }
    user { payment_method.user }
    amount { 100 }
    currency { payment_method.currency }
  end
end
