class CompanyJbuilder
  attr_accessor :model

  def initialize(model)
    @model = model
  end

  def call
    if model.respond_to?(:each)
      model.map { |company| build_json(company) }
    else
      build_json(model)
    end
  end

  private

  def build_json(company)
    Jbuilder.new do |json|
      json.id company.id
      json.type 'companies'
      json.attributes do
        json.call(company, :name, :cnpj, :email, :created_at, :updated_at)
      end
    end.attributes!
  end
end
