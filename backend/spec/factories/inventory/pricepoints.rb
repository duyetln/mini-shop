FactoryGirl.define do
  factory :pricepoint do
    name {  Faker::Lorem.characters(20) }

    after(:create) do |pricepoint|
      [:usd, :eur, :gbp].each do |curr|
        PricepointPrice.create(
          pricepoint_id: pricepoint.id,
          amount: rand(50),
          currency_id: create(curr).id
        )
      end
    end
  end
end
