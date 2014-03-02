FactoryGirl.define do
  factory :user do
    
    first_name "John"
    last_name  "Smith"
    email      "john.smith@email.com"
    birthdate  Date.today
    password   "password"

    trait :actv_code_blank do
      actv_code nil
    end

    trait :actv_code_present do
      actv_code SecureRandom.hex(5)
    end
  end
end