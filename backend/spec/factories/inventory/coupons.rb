FactoryGirl.define do
  factory :coupon do
    batch { build :batch }
  end
end
