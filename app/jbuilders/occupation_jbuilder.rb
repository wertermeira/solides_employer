class OccupationJbuilder
  attr_accessor :occupation

  def initialize(occupation)
    @occupation = occupation
  end

  def call
    Jbuilder.new do |json|
      json.id occupation.id
      json.type 'occupations'
      json.attributes do
        json.name occupation.name
        json.active occupation.active
        json.created_at occupation.created_at
        json.updated_at occupation.updated_at
      end
    end.attributes!
  end
end
