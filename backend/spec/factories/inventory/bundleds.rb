FactoryGirl.define do
  factory :bundled do
    bundle { build :bundle }
    item { build [:digital_item, :physical_item].sample }
    qty { rand(1..10) }
  end
end
