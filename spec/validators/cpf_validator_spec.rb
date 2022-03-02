require 'rails_helper'

module Test
  CpfValidatable = Struct.new(:cpf) do
    include ActiveModel::Validations

    validates :cpf, cpf: true
  end
end

RSpec.describe CpfValidator, type: :model do
  subject(:model) { Test::CpfValidatable.new '000.000.000-00' }

  describe '.valid' do
    context 'when valid' do
      it { is_expected.to be_valid }
    end

    context 'when invalid' do
      it do
        model.cpf = '000.000.00000'
        model.valid?
        expect(model.errors[:cpf]).to match_array(I18n.t('errors.messages.invalid_cpf'))
      end
    end
  end
end
