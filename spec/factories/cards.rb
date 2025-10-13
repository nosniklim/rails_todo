FactoryBot.define do
  factory :card do
    title { 'Sample Card' }
    memo { 'This is a sample card.' }
    position { 1 }
    association :list
  end
end
