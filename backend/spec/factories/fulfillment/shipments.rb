FactoryGirl.define do
  factory :shipment do
    user { build :user }
    order { build :order, :physical_item }
    item { order.item }
    qty { order.qty }
    shipping_address { build :address, user: user }
  end
end
