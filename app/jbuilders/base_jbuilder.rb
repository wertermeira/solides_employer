class BaseJbuilder
  attr_accessor :model, :options

  def initialize(model, options: {})
    @model = model
    @options = options
  end

  def call
    if model.respond_to?(:each)
      { data: model.map { |company| build_json(company) }, meta: { pagination: pagination } }
    else
      { data: build_json(model) }
    end
  end

  private

  def build_json(model)
    Jbuilder.new do |json|
      json.id model.id
      json.type model.class.name.downcase.pluralize
      json.attributes do
        model.attributes.except('id').each_key do |attr|
          json.call(model, attr)
        end
      end
    end.attributes!
  end

  def pagination
    return if model.try(:current_page).nil?

    current = model.current_page
    total = model.total_pages
    per_page = model.try(:limit_value)
    Jbuilder.new do |json|
      json.current current
      json.previous current > 1 ? (current - 1) : nil
      json.next current < total ? (current + 1) : nil
      json.per_page per_page
      json.pages total
      json.total_count model.total_count
    end.attributes!
  end
end
