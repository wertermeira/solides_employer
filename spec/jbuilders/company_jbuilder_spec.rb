require 'rails_helper'

RSpec.describe CompanyJbuilder do
  let(:company) { create(:company) }
  let(:estructure) {
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

  describe '#call' do
    it do
      expect(described_class.new(company).call).to eq(estructure.deep_stringify_keys)
    end
  end
end