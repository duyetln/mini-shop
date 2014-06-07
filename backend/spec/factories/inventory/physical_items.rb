FactoryGirl.define do
  factory :physical_item do
    title 'Title'
    description 'Description'
    qty { 10_000 }
  end
end
