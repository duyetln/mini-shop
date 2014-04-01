FactoryGirl.define do
  factory :order do
    purchase { build :purchase }
    item { build :storefront_item }
    qty { rand(1..10) }
    currency { build :usd }
  end
end
