FactoryGirl.define do
  factory :promotion do
    name 'Name'
    title 'Title'
    description 'Description'
    item { build [:bundle, :physical_item, :digital_item].sample }
    price { build :price, discount: build(:discount, :full) }

    trait :coupons do
      after :build do |promotion|
        rand(1..3).times { promotion.batches << build(:batch, :coupons) }
      end
    end
  end
end
