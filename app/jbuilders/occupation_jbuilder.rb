class OccupationJbuilder
  attr_accessor :model

  def initialize(model)
    @model = model
  end

  def call
    if model.respond_to?(:each)
      model.map { |occupation| build_json(occupation) }
    else
      build_json(model)
    end
  end

  private

  def build_json(occupation)
    Jbuilder.new do |json|
      json.id occupation.id
      json.type 'occupations'
      json.attributes do
        json.call(occupation, :name, :active, :created_at, :updated_at)
      end
    end.attributes!
  end
end
