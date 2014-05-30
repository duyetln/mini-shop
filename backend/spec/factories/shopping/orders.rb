FactoryGirl.define do
  factory :order do
    purchase { build :purchase }
    item { build [:bundle, :physical_item, :digital_item].sample }
    qty { rand(1..10) }
    amount { rand(5..20) * qty }
    currency { build :usd }

    trait :physical_item do
      item { build :physical_item }
    end

    trait :digital_item do
      item { build :digital_item }
    end
  end
end
