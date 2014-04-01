FactoryGirl.define do
  factory :bundle_item do
    title 'Title'
    description 'Description'

    trait :bundlings do
      after :build do |bundle_item|
        bundle_item.bundlings << build(:bundling)
      end
    end
  end
end
