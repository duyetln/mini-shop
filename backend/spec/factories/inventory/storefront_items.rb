FactoryGirl.define do
  factory :storefront_item do
    title "Title"
    description "Description"
    price { FactoryGirl.create(:price, :discounted) }
    item { FactoryGirl.create([ :bundle_item, :physical_item, :digital_item ].sample) }
  end
end