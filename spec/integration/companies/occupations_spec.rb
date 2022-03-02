require 'swagger_helper'

RSpec.describe '/companies/{company_id}/occupations', type: :request do
  path '/companies/{company_id}/occupations' do
    get 'List occupations' do
      tags 'Companies/Occupations'
      produces 'application/json'
      parameter name: :company_id, in: :path, type: :string

      response '200', 'List occupations' do
        schema type: :object, properties: {
          data: { type: :array, items: { '$ref' => '#/components/schemas/Occupation' } }
        }
        let(:occupations_count) { rand(1..10) }
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        before do
          create_list(:occupation, occupations_count, company: company)
        end

        run_test! do
          expect(json_body.dig('data').count).to eq(occupations_count)
        end
      end
    end

    post 'Create occupation' do
      tags 'Companies/Occupations'
      consumes 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :occupation, in: :body, schema: {
        type: :object,
        properties: {
          occupation: {
            type: :object,
            properties: {
              name: { type: :string },
              active: { type: :boolean }
            },
            required: %w[name active]
          }
        }
      }

      response 201, 'Occupation created' do
        schema type: :object, properties: {
          data: { '$ref' => '#/components/schemas/Occupation' }
        }
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        let(:occupation) do
          {
            occupation: {
              name: Faker::Job.title,
              active: true
            }
          }
        end
        run_test!
      end

      response 422, 'Invalid request' do
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        let(:occupation) do
          {
            occupation: {
              name: '',
              active: true
            }
          }
        end
        run_test! do
          expect(json_body.dig('errors')).to be_present
        end
      end
    end
  end

  path '/companies/{company_id}/occupations/{id}' do
    get 'Show occupation' do
      tags 'Companies/Occupations'
      produces 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response 200, 'Occupation found' do
        schema type: :object, properties: {
          data: { '$ref' => '#/components/schemas/Occupation' }
        }
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        let(:occupation) { create(:occupation, company: company) }
        let(:id) { occupation.id }
        run_test!
      end

      response 404, 'Occupation not found' do
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Update occupation' do
      tags 'Companies/Occupations'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :occupation, in: :body, schema: {
        type: :object,
        properties: {
          occupation: {
            type: :object,
            properties: {
              name: { type: :string },
              active: { type: :boolean }
            },
            required: %w[name active]
          }
        }
      }

      response 202, 'Occupation updated' do
        schema type: :object, properties: {
          data: { '$ref' => '#/components/schemas/Occupation' }
        }
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        let(:occupation_item) { create(:occupation, company: company) }
        let(:id) { occupation_item.id }
        let(:occupation) do
          {
            occupation: {
              name: Faker::Job.title,
              active: [true, false].sample
            }
          }
        end
        %w[name active].each do |field|
          context "when #{field} updated" do
            run_test! do
              expect(json_body.dig('data', 'attributes', field)).to eq(occupation[:occupation][field.to_sym])
            end
          end
        end
      end

      response 422, 'Invalid request' do
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        let(:occupation_item) { create(:occupation, company: company) }
        let(:id) { occupation_item.id }
        let(:occupation) do
          {
            occupation: {
              name: '',
              active: true
            }
          }
        end
        run_test! do
          expect(json_body.dig('errors')).to be_present
        end
      end
    end

    delete 'Delete occupation' do
      tags 'Companies/Occupations'
      produces 'application/json'
      parameter name: :company_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response 204, 'Occupation deleted' do
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        let(:occupation) { create(:occupation, company: company) }
        let(:id) { occupation.id }
        run_test!
      end

      response 404, 'Occupation not found' do
        let(:company) { create(:company) }
        let(:company_id) { company.id }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
