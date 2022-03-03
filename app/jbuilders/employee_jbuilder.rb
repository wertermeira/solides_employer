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
        json.call(employee, :name, :cpf, :email, :phone_number, :start_date,
                  :end_date, :montly_salary, :created_at, :updated_at)
        json.occupation do
          json.call(employee.occupation, :id, :name)
        end
        json.company do
          json.call(employee.company, :id, :name)
        end
      end
    end.attributes!
  end
end
