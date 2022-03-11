require 'swagger_helper'

RSpec.describe '/companies', type: :request do
  path '/companies' do
    get 'List companies' do
      let(:companies_count) { rand(1..10) }
      tags 'Companies'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      response 200, 'companies found' do
        schema type: :object,
               properties: {
                 data: { type: :array, items: { '$ref' => '#/components/schemas/Company' } },
                 meta: { type: :object, properties: { pagination: { '$ref' => '#/components/schemas/Pagination' } } }
               }

        before do
          create_list(:company, companies_count)
        end
        context 'when has filters' do
          let(:page) { 2 }
          let(:per_page) { 20 }
          let(:companies_count) { 25 }
          run_test! do
            expect(json_body.dig('data').count).to eq(5)
          end
        end

        context 'when without filters' do
          run_test! do
            expect(json_body.dig('data').count).to eq(companies_count)
          end
        end
      end
    end

    post 'Create company' do
      tags 'Companies'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          company: {
            type: :object,
            properties: {
              name: { type: :string },
              cnpj: { type: :string },
              email: { type: :string }
            },
            required: %w[name cnpj email]
          }
        }
      }

      response 201, 'company created' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/Company' }
               }
        let(:attributes) do
          {
            company: {
              name: Faker::Company.name,
              cnpj: Faker::Company.brazilian_company_number(formatted: true),
              email: Faker::Internet.email
            }
          }
        end
        let(:company) { attributes }
        run_test!
      end

      response 422, 'invalid request' do
        let(:attributes) do
          {
            company: {
              name: '',
              cnpj: Faker::Company.brazilian_company_number(formatted: true),
              email: Faker::Internet.email
            }
          }
        end
        let(:company) { attributes }
        run_test! do
          expect(json_body.dig('errors')).to be_present
        end
      end
    end
  end

  path '/companies/{id}' do
    let(:company_item) { create(:company) }

    get 'Show company' do
      tags 'Companies'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response 200, 'company found' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/Company' }
               }

        let(:id) { create(:company).id }
        run_test!
      end

      response 404, 'company not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Update company' do
      tags 'Companies'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          company: {
            type: :object,
            properties: {
              name: { type: :string },
              cnpj: { type: :string },
              email: { type: :string }
            },
            required: %w[name cnpj email]
          }
        }
      }

      response 202, 'company updated' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/Company' }
               }

        let(:id) { company_item.id }
        let(:attributes) do
          {
            company: {
              name: Faker::Company.name,
              cnpj: Faker::Company.brazilian_company_number(formatted: true),
              email: Faker::Internet.email
            }
          }
        end
        let(:company) { attributes }

        %w[name cnpj email].each do |field|
          context "when #{field} is updated" do
            run_test! do
              expect(json_body.dig('data', 'attributes', field)).to eq(attributes[:company][field.to_sym])
            end
          end
        end
      end

      response 422, 'invalid request' do
        let(:id) { company_item.id }
        let(:attributes) do
          {
            company: {
              name: '',
              cnpj: Faker::Company.brazilian_company_number(formatted: true),
              email: Faker::Internet.email
            }
          }
        end
        let(:company) { attributes }
        run_test! do
          expect(json_body.dig('errors')).to be_present
        end
      end
    end

    delete 'Delete company' do
      tags 'Companies'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response 204, 'company deleted' do
        let(:id) { company_item.id }
        run_test!
      end

      response 404, 'company not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
