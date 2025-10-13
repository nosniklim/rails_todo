require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:lists).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(20) }
  end

  describe 'include module' do
    it 'includes Devise' do
      expect(User.ancestors).to include(Devise::Models::DatabaseAuthenticatable)
      expect(User.ancestors).to include(Devise::Models::Registerable)
      expect(User.ancestors).to include(Devise::Models::Recoverable)
      expect(User.ancestors).to include(Devise::Models::Rememberable)
      expect(User.ancestors).to include(Devise::Models::Validatable)
    end
  end
end