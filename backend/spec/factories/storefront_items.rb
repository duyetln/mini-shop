FactoryGirl.define do
  factory :storefront_item do
    title "Title"
    description "Description"
    active true
    removed false

    after :build do |item, evaluator|
      item.item   = FactoryGirl.create([:physical_item, :digital_item, :bundle_item].sample)
      item.price = FactoryGirl.create(:price)
    end
  end
end