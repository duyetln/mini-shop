FactoryGirl.define do
  factory :bundling do
    bundle { build :bundle_item }
    item { build [:digital_item, :physical_item].sample }
    qty 1
  end
end
