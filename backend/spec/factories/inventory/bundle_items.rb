FactoryGirl.define do
  factory :bundle_item do
    title "Title"
    description "Description"

    after(:create) do |bundle_item|
      3.times do
        bundle_item.add_or_update(create([ :digital_item, :physical_item ].sample))
      end
    end
  end
end