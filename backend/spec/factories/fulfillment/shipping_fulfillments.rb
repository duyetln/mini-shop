FactoryGirl.define do
  factory :shipping_fulfillment do
    order { build :order, :physical_item }
    item { order.item.item }
  end
end
