FactoryGirl.define do
  factory :usd, class: Currency do
    initialize_with { Currency.where(code: 'USD').first_or_create }
  end

  factory :eur, class: Currency do
    initialize_with { Currency.where(code: 'EUR').first_or_create }
  end

  factory :gbp, class: Currency do
    initialize_with { Currency.where(code: 'GBP').first_or_create }
  end
end
