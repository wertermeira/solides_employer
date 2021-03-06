require 'rails_helper'

module Test
  CnpjValidatable = Struct.new(:cnpj) do
    include ActiveModel::Validations

    validates :cnpj, cnpj: true
  end
end

RSpec.describe CnpjValidator, type: :model do
  subject(:model) { Test::CnpjValidatable.new '72.693.142/0001-92' }

  describe '.valid' do
    context 'when valid' do
      it { is_expected.to be_valid }
    end

    context 'when invalid' do
      it do
        model.cnpj = '72.693.142/0001-911'
        model.valid?
        expect(model.errors[:cnpj]).to match_array(I18n.t('errors.messages.invalid_cnpj'))
      end
    end
  end
end
