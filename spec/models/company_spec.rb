require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'when db schema' do
    let(:model) { described_class.column_names }

    %w[name cnpj email].each do |field|
      it { expect(model).to include(field) }
    end
  end

  describe 'when has associations' do
    it { is_expected.to have_many(:occupations).dependent(:destroy) }
  end

  describe 'when validations' do
    %i[name cnpj email].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end

    %i[email cnpj].each do |field|
      it { is_expected.to validate_uniqueness_of(field) }
    end

    it { is_expected.to validate_length_of(:name).is_at_most(100) }

    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('userexample.com').for(:email) }

    it { is_expected.to allow_value('01.123.456/0001-01').for(:cnpj) }
    it { is_expected.not_to allow_value('a').for(:cnpj) }
  end
end
