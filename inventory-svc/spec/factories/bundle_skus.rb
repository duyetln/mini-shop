FactoryGirl.define do
  factory :bundle_sku do
    title "Title"
    description "Description"
    active true
    removed false

    after(:build) do |bundle_sku, evaluator|
      rand(1..5).times { bundle_sku.physical_skus << build(:physical_sku) }
      rand(1..5).times { bundle_sku.digital_skus  << build(:digital_sku)  }
    end
  end
end