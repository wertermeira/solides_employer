require 'rails_helper'

RSpec.describe OccupationJbuilder do
  let(:occupation) { create(:occupation) }
  let(:estructure) do
    {
      id: occupation.id,
      type: 'occupations',
      attributes: {
        name: occupation.name,
        active: occupation.active,
        created_at: occupation.created_at,
        updated_at: occupation.updated_at
      }
    }
  end

  describe '#call' do
    it do
      expect(described_class.new(occupation).call).to eq(estructure.deep_stringify_keys)
    end
  end
end
