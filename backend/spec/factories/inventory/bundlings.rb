FactoryGirl.define do
  factory :bundling do
    bundle { create :bundle_item }
    item { create [:digital_item, :physical_item].sample }
    qty 1
  end
end
