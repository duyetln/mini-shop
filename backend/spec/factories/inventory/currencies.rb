FactoryGirl.define do
  factory :usd, class: Currency do
    initialize_with { Currency.where(code: 'USD', sign: '&#36;').first_or_create }
  end

  factory :eur, class: Currency do
    initialize_with { Currency.where(code: 'EUR', sign: '&#128;').first_or_create }
  end

  factory :gbp, class: Currency do
    initialize_with { Currency.where(code: 'GBP', sign: '&#163;').first_or_create }
  end
end
