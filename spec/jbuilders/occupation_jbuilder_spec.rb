require 'rails_helper'

RSpec.describe OccupationJbuilder do
  let(:occupation) { create(:occupation) }
  let(:structure) do
    lambda { |occupation|
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
    }
  end

  describe '#call' do
    context 'when is a single occupation' do
      it do
        expect(described_class.new(occupation).call).to eq(structure[occupation].deep_stringify_keys)
      end
    end

    context 'when is a collection of occupations' do
      let(:occupations) { create_list(:occupation, 3) }
      let(:structure_collection) do
        occupations.map { |occupation| structure[occupation].deep_stringify_keys }
      end

      it do
        expect(described_class.new(occupations).call).to eq(structure_collection)
      end
    end
  end
end
