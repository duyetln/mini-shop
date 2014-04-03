FactoryGirl.define do
  factory :order do
    purchase { build :purchase }
    item { build :storefront_item }
    qty { rand(1..10) }
    currency { build :usd }

    trait :physical_item do
      item { build :storefront_item, :physical_item }
    end

    trait :digital_item do
      item { build :storefront_item, :digital_item }
    end
  end
end
