FactoryGirl.define do
  factory :store_item do
    name 'Name'
    price { build :price, :discounted }
    item { build [:bundle, :physical_item, :digital_item].sample }

    trait :bundle do
      item { build :bundle, :bundleds }
    end

    trait :physical_item do
      item { build :physical_item }
    end

    trait :digital_item do
      item { build :digital_item }
    end
  end
end
