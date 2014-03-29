FactoryGirl.define do
  factory :physical_item do
    title 'Title'
    description 'Description'
    quantity { rand(1..10) }
  end
end
