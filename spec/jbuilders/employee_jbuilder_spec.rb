require 'rails_helper'

RSpec.describe EmployeeJbuilder do
  let(:employee) { create(:employee) }
  let(:structure) do
    {
      id: employee.id,
      type: 'employees',
      attributes: {
        name: employee.name,
        cpf: employee.cpf,
        email: employee.email,
        phone_number: employee.phone_number,
        start_date: employee.start_date,
        end_date: employee.end_date,
        montly_salary: employee.montly_salary,
        created_at: employee.created_at,
        updated_at: employee.updated_at,
        occupation: {
          id: employee.occupation.id,
          name: employee.occupation.name
        },
        company: {
          id: employee.company.id,
          name: employee.company.name
        }
      }
    }
  end

  describe '#call' do
    it do
      expect(described_class.new(employee).call).to eq(structure.deep_stringify_keys)
    end
  end
end
