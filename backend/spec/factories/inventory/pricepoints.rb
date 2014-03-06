FactoryGirl.define do
  factory :pricepoint do
    name {  Faker::Lorem.characters(20) }

    after(:create) do |pricepoint|
      ["USD", "EUR", "GBP"].each do |curr|
        PricepointPrice.create( 
          pricepoint_id: pricepoint.id,
          amount: rand(50), 
          currency_id: Currency.where(code: curr).first_or_create.id
        )
      end
    end
  end
end