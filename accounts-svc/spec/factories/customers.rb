FactoryGirl.define do
  factory :customer do
    
    first_name "John"
    last_name  "Smith"
    email      "john.smith@email.com"
    birthdate  Date.today
    password   "password"

    trait :saved do
      uuid     SecureRandom.hex(5)
      password BCrypt::Password.create("password")
    end

    trait :confirmed do
      confirmation_code nil
    end

    trait :unconfirmed do
      confirmation_code SecureRandom.hex(5)
    end
  end
end