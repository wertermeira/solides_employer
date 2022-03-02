class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, content)
    message = I18n.t('errors.messages.invalid_cpf')
    regex_cpf = /^\d{3}\.\d{3}\.\d{3}-\d{2}$/
    record.errors.add(attribute, options[:message] || message) unless content.match?(regex_cpf)
  end
end
