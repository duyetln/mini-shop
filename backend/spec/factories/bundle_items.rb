FactoryGirl.define do
  factory :bundle_item do
    title "Title"
    description "Description"
    active true
    deleted false

    after :build do |bundle_item, evaluator|
      rand(1..5).times { bundle_item.physical_items << build(:physical_item) }
      rand(1..5).times { bundle_item.digital_items  << build(:digital_item)  }
    end
  end
end