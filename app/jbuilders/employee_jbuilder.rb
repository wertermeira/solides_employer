class EmployeeJbuilder
  attr_accessor :employee

  def initialize(employee)
    @employee = employee
  end

  def call
    Jbuilder.new do |json|
      json.id employee.id
      json.type 'employees'
      json.attributes do
        json_attributes(json)
        json.occupation do
          json.id employee.occupation.id
          json.name employee.occupation.name
        end
        json.company do
          json.id employee.company.id
          json.name employee.company.name
        end
      end
    end.attributes!
  end

  private

  def json_attributes(json)
    json.name employee.name
    json.cpf employee.cpf
    json.email employee.email
    json.phone_number employee.phone_number
    json.start_date employee.start_date
    json.end_date employee.end_date
    json.montly_salary employee.montly_salary
    json.created_at employee.created_at
    json.updated_at employee.updated_at
  end
end
