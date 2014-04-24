FactoryGirl.define do
  factory :ownership do
    user { order.user }
    order { build :order, :digital_item }
    item { order.item.item }
    qty { order.qty }
  end
end
