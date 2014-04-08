FactoryGirl.define do
  factory :online_fulfillment do
    order { build :order, :digital_item }
    item { order.item.item }
    qty { order.qty }
  end
end
