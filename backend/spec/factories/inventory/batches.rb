FactoryGirl.define do
  factory :batch do
    name 'Name'
    promotion { build :promotion }

    trait :coupons do
      after :build do |batch|
        rand(3..6).times { batch.coupons << build(:coupon) }
      end
    end
  end
end
