require 'swagger_helper'

RSpec.describe '/companies/{company_id}/employees', type: :request do
  let(:company) { create(:company) }
  let(:company_id) { company.id }

  path '/companies/{company_id}/employees' do
    get 'List employees' do
      tags 'Companies/Employees'
      produces 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      response 200, 'Success' do
        schema type: :object, properties: {
          data: { type: :array, items: { '$ref' => '#/components/schemas/Employee' } },
          meta: { type: :object, properties: { pagination: { '$ref' => '#/components/schemas/Pagination' } } }
        }
        let(:employees_count) { rand(1..10) }
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        before do
          create_list(:employee, employees_count, company: company)
        end

        run_test! do
          expect(json_body.dig('data').count).to eq(employees_count)
        end
      end
    end

    post 'Create employee' do
      let(:attributes) do
        {
          employee: {
            name: Faker::Name.name,
            cpf: Faker::IDNumber.brazilian_citizen_number(formatted: true),
            email: Faker::Internet.email,
            phone_number: '11-11111-1111',
            start_date: Faker::Date.between(from: 2.years.ago, to: Time.zone.today),
            montly_salary: Faker::Number.decimal(l_digits: 3, r_digits: 2),
            occupation_id: create(:occupation, company: company).id
          }
        }
      end

      tags 'Companies/Employees'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :employee, in: :body, schema: {
        type: :object,
        properties: {
          employee: {
            type: :object,
            properties: {
              name: { type: :string },
              cpf: { type: :string },
              email: { type: :string },
              phone_number: { type: :string },
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: 'date', nullable: true },
              montly_salary: { type: :string, nullable: true },
              occupation_id: { type: :string }
            },
            required: %w[name cpf email phone_number start_date occupation_id]
          }
        }
      }

      response 201, 'Created' do
        let(:employee) { attributes }
        run_test!
      end

      response 422, 'Unprocessable Entity' do
        before do
          attributes[:employee][:name] = ''
        end
        let(:employee) { attributes }
        run_test!
      end
    end
  end

  path '/companies/{company_id}/employees/{id}' do
    let(:employee_item) { create(:employee, company: company) }

    get 'Show employee' do
      tags 'Companies/Employees'
      produces 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response 200, 'Success' do
        let(:id) { employee_item.id }
        run_test!
      end

      response 404, 'Not Found' do
        let(:id) { create(:employee).id }
        run_test!
      end
    end

    put 'Update employee' do
      let(:attributes) do
        {
          employee: {
            name: Faker::Name.name,
            cpf: Faker::IDNumber.brazilian_citizen_number(formatted: true),
            email: Faker::Internet.email,
            phone_number: '11-11111-1111'
          }
        }
      end
      tags 'Companies/Employees'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :employee, in: :body, schema: {
        type: :object,
        properties: {
          employee: {
            type: :object,
            properties: {
              name: { type: :string },
              cpf: { type: :string },
              email: { type: :string },
              phone_number: { type: :string },
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: 'date', nullable: true },
              montly_salary: { type: :string, nullable: true },
              occupation_id: { type: :string }
            },
            required: %w[name cpf email phone_number start_date occupation_id]
          }
        }
      }

      response 202, 'Updated' do
        let(:id) { employee_item.id }

        let(:employee) { attributes }
        %w[name cpf email phone_number].each do |field|
          context "when #{field} is updated" do
            run_test! do
              expect(json_body.dig('data', 'attributes', field)).to eq(attributes[:employee][field.to_sym])
            end
          end
        end
      end

      response 422, 'Unprocessable Entity' do
        let(:id) { employee_item.id }
        before do
          attributes[:employee][:name] = ''
        end
        let(:employee) { attributes }
        run_test! do
          expect(json_body.dig('errors')).to be_present
        end
      end
    end

    delete 'Delete employee' do
      tags 'Companies/Employees'
      produces 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response 204, 'Deleted' do
        let(:id) { employee_item.id }
        run_test!
      end
    end
  end
end
