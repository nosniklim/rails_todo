require 'rails_helper'

RSpec.describe List, type: :model do
  let(:described_instance) { create(:list) }
  subject { described_instance }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { should have_many(:cards).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_length_of(:title).is_at_least(1).is_at_most(255) }
  end

  describe 'include module' do
    it { is_expected.to be_a(UtilityMethods) }
  end

  describe 'instance methods' do
    describe '#save' do
      subject { described_instance.save }
      it { is_expected.to be_truthy }
    end
  end
end