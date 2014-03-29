FactoryGirl.define do
  factory :storefront_item do
    name 'Name'
    price { create :price, :discounted }
    item { create [:bundle_item, :physical_item, :digital_item].sample }
  end
end
