class CnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, content)
    regex_cnpj = %r{^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$}
    message = I18n.t('errors.messages.invalid_cnpj')
    record.errors.add(attribute, options[:message] || message) unless content.match?(regex_cnpj)
  end
end
