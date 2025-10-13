FactoryBot.define do
  factory :user do
    name { Faker::Internet.unique.username(specifier: 2..20) }
    email { Faker::Internet.unique.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
