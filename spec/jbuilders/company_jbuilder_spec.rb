require 'rails_helper'

RSpec.describe CompanyJbuilder do
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
        expect(described_class.new(company).call).to eq(structure[company].deep_stringify_keys)
      end
    end

    context 'when is a collection of companies' do
      let(:companies) { create_list(:company, 3) }
      let(:structure_collection) do
        companies.map { |company| structure[company].deep_stringify_keys }
      end

      it do
        expect(described_class.new(companies).call).to eq(structure_collection)
      end
    end
  end
end
