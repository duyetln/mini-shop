FactoryGirl.define do
  factory :order do
    purchase { create :purchase, :ready }
    item { create :storefront_item }
    qty { rand(1..10) }
    currency { create :usd }
  end
end
