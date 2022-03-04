require 'rails_helper'

RSpec.describe BaseJbuilder do
  let(:company) { create(:company) }
  let(:structure) do
    lambda { |company|
      {
        id: company.id,
        type: 'companies',
        attributes: {
          name: company.name,
          cnpj: company.cnpj,
          email: company.email,
          created_at: company.created_at,
          updated_at: company.updated_at
        }
      }
    }
  end

  describe '#call' do
    context 'when is a single company' do
      it do
        expect(described_class.new(company).call[:data]).to eq(structure[company].deep_stringify_keys)
      end
    end

    context 'when is a collection of companies' do
      let(:companies) { create_list(:company, 3) }
      let(:structure_collection) do
        companies.map { |company| structure[company].deep_stringify_keys }
      end

      it do
        expect(described_class.new(companies).call[:data]).to eq(structure_collection)
      end
    end

    context 'when is blank' do
      let(:all) { [] }
      it do
        expect(described_class.new(all).call[:data]).to eq([])
      end
    end

    context 'when pagination is present' do
      let(:companies) do
        create_list(:company, rand(5..20))
        Company.all
      end
      let(:options) { { per_page: 2 } }
      let(:structure) do
        {
          pagination: {
            current: 1,
            next: nil,
            pages: 1,
            per_page: options[:per_page],
            previous: nil,
            total_count: companies.count
          }.deep_stringify_keys
        }
      end

      it 'with options' do
        expect(described_class.new(companies.page(1),
                                   options: options).call[:meta][:pagination]).to eq(structure[:pagination])
      end

      it 'without options' do
        options[:per_page] = 20
        expect(described_class.new(companies.page(1)).call[:meta][:pagination]).to eq(structure[:pagination])
      end
    end
  end
end
