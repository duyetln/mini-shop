FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name.gsub(/[^a-zA-Z]+/, '') }
    last_name  { Faker::Name.last_name.gsub(/[^a-zA-Z]+/, '') }
    email      { Faker::Internet.email(first_name + last_name) }
    birthdate  { '1990-11-15' }
    password   { Faker::Lorem.characters(20) }
  end
end
