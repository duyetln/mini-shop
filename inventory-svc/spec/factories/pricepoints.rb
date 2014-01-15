FactoryGirl.define do
  factory :pricepoint do
    name { SecureRandom.hex }

    after :create do |pp, evaluator|
      [:usd, :eur, :gbp].each do |currency| 
        PricepointPrice.create(amount: rand(50), pricepoint: pp, currency: Currency.where(code: currency.to_s.upcase).first_or_create)
      end
    end
  end
end