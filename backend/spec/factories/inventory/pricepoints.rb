FactoryGirl.define do
  factory :pricepoint do
    name {  Faker::Lorem.characters(20) }

    trait :pricepoint_prices do
      after :build do |pricepoint|
        [:usd, :eur, :gbp].each do |curr|
          pricepoint.pricepoint_prices << build(:pricepoint_price, curr)
        end
      end
    end
  end
end
