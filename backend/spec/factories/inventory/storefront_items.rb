FactoryGirl.define do
  factory :storefront_item do
    name "Name"
    price { FactoryGirl.create(:price, :discounted) }
    item { FactoryGirl.create([ :bundle_item, :physical_item, :digital_item ].sample) }
  end
end