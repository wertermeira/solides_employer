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
        json.call(company, :name, :cnpj, :email, :created_at, :updated_at)
      end
    end.attributes!
  end
end
