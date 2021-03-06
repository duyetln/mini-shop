FactoryGirl.define do
  factory :order do
    purchase { build :purchase }
    qty { rand(1..10) }
    amount { rand(5..20) * qty }
    currency { build :usd }
    item do
      build(
      *[
        [
          [:bundle, :bundleds],
          :digital_item,
          :physical_item
        ].sample
      ].flatten)
    end

    trait :physical_item do
      item { build :physical_item }
    end

    trait :digital_item do
      item { build :digital_item }
    end
  end
end
