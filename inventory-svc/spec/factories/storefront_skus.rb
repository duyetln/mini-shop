FactoryGirl.define do
  factory :storefront_sku do
    title "Title"
    description "Description"
    active true
    removed false

    after :build do |sku, evaluator|
      sku.sku = FactoryGirl.build([:physical_sku, :digital_sku, :bundle_sku].sample)
    end
  end
end