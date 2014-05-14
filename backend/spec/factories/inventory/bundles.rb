FactoryGirl.define do
  factory :bundle do
    title 'Title'
    description 'Description'

    trait :bundlings do
      after :build do |bundle|
        bundle.bundlings << build(:bundling)
      end
    end
  end
end
