FactoryGirl.define do
  factory :storefront_item do
    name "Name"
    association :price, :discounted
    association :item,  factory: [ :bundle_item, :physical_item, :digital_item ].sample
  end
end