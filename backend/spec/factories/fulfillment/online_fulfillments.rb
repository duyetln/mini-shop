FactoryGirl.define do
  factory :online_fulfillment do
    order { build :order, :digital_item }
    item { order.item }
    qty { order.qty }
  end
end
