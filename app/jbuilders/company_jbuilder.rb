class CompanyJbuilder
  attr_accessor :company

  def initialize(company)
    @company = company
  end

  def call
    Jbuilder.new do |json|
      json.id company.id
      json.type 'companies'
      json.attributes do
        json.name company.name
        json.cnpj company.cnpj
        json.email company.email
        json.created_at company.created_at
        json.updated_at company.updated_at
      end
    end.attributes!
  end
end
