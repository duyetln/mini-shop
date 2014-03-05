FactoryGirl.define do
  factory :pricepoint do
    name { SecureRandom.hex }
  end
end