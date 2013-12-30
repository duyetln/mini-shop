FactoryGirl.define do
  factory :physical_sku do
    title "Title"
    description "Description"
    active true
    quantity { rand(1..10) }
    removed false
  end
end