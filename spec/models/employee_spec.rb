require 'rails_helper'

RSpec.describe Employee, type: :model do
  let(:company) { create(:company) }
  let(:attributes_employee) do
    {
      company: create(:company),
      occupation: create(:occupation, company: company),
      name: Faker::Name.name,
      cpf: Faker::IDNumber.brazilian_citizen_number(formatted: true),
      email: Faker::Internet.email,
      phone_number: '11-11111-1111'
    }
  end

  describe 'when db schema' do
    let(:model) { described_class.column_names }

    %w[id company_id occupation_id name cpf email phone_number start_date end_date montly_salary created_at
       updated_at].each do |field|
      it { expect(model).to include(field) }
    end
  end

  describe 'when has associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:occupation) }
  end

  describe 'when validations' do
    %w[name cpf email phone_number start_date].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end

    it { is_expected.to validate_length_of(:name).is_at_most(100) }
    it { is_expected.to allow_value(Faker::IDNumber.brazilian_citizen_number(formatted: true)).for(:cpf) }
    it { is_expected.not_to allow_value(Faker::IDNumber.brazilian_citizen_number).for(:cpf) }
    it { is_expected.to allow_value(Faker::Internet.email).for(:email) }
    it { is_expected.not_to allow_value('email.site.com').for(:email) }
    it { is_expected.to allow_value('11-11111-1111').for(:phone_number) }
    it { is_expected.to allow_value('11-1111-1111').for(:phone_number) }
    it { is_expected.not_to allow_value('11-11111-11111111').for(:phone_number) }

    context 'when unique' do
      subject { described_class.new(company: company, occupation: create(:occupation, company: company)) }
      %w[email cpf].each do |field|
        it { is_expected.to validate_uniqueness_of(field) }
      end
    end

    context 'when validate start_date' do
      it '.valid?' do
        attributes_employee[:start_date] = Faker::Date.between(from: 2.years.ago, to: Date.today)
        expect(described_class.new(attributes_employee)).to be_valid
      end

      it '.invalid?' do
        attributes_employee[:start_date] = Date.today + 1.day
        expect(described_class.new(attributes_employee)).not_to be_valid
      end
    end

    context 'when validate end_date' do
      it '.valid?' do
        attributes_employee[:start_date] = Faker::Date.between(from: 2.years.ago, to: Date.today)
        attributes_employee[:end_date] = Date.today + 1.day
        expect(described_class.new(attributes_employee)).to be_valid
      end

      it '.invalid?' do
        attributes_employee[:start_date] = Date.today
        attributes_employee[:end_date] = Date.today - 1.day
        expect(described_class.new(attributes_employee)).not_to be_valid
      end
    end
  end
end
