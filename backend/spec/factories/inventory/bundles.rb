FactoryGirl.define do
  factory :bundle do
    title 'Title'
    description 'Description'

    trait :bundleds do
      after :build do |bundle|
        bundle.bundleds << build(:bundled)
      end
    end
  end
end
