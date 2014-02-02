FactoryGirl.define do
  factory :user do
    
    first_name "John"
    last_name  "Smith"
    email      "john.smith@email.com"
    birthdate  Date.today
    password   "password"

    trait :confirmation_code_blank do
      confirmation_code nil
    end

    trait :confirmation_code_present do
      confirmation_code SecureRandom.hex(5)
    end
  end
end