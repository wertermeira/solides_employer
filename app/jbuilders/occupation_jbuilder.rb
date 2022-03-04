class OccupationJbuilder < BaseJbuilder
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
