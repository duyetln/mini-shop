FactoryGirl.define do
  factory :physical_item do
    title "Title"
    description "Description"
    active true
    quantity { rand(1..10) }
    deleted false
  end
end