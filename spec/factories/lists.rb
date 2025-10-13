FactoryBot.define do
  factory :list do
    title { 'Sample List' }
    position { 1 }
    association :user
  end
end
