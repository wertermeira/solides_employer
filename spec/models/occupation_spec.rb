require 'rails_helper'

RSpec.describe Occupation, type: :model do
  describe 'when db schema' do
    let(:model) { described_class.column_names }

    %w[name active company_id].each do |field|
      it { expect(model).to include(field) }
    end
  end

  describe 'when has associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:employees).dependent(:nullify) }
  end

  describe 'when validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
  end
end
