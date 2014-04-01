FactoryGirl.define do
  factory :storefront_item do
    name 'Name'
    price { build :price, :discounted }
    item { build [:bundle_item, :physical_item, :digital_item].sample }

    trait :bundle_item do
      item { build :bundle_item, :bundlings }
    end

    trait :physical_item do
      item { build :physical_item }
    end

    trait :digital_item do
      item { build :digital_item }
    end
  end
end
