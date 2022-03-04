# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      components: {
        schemas: {
          Pagination: {
            type: :object,
            properties: {
              current: { type: :integer },
              previous: { type: :integer, nullable: true },
              next: { type: :integer, nullable: true },
              per_page: { type: :integer, nullable: true },
              pages: { type: :integer, nullable: true },
              total_count: { type: :integer, nullable: true }
            }
          },
          Employee: {
            type: :object,
            properties: {
              id: { type: :string },
              name: { type: :string, example: 'employees' },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  cpf: { type: :string },
                  email: { type: :string },
                  phone_number: { type: :string, nullable: true },
                  montly_salary: { type: :string, nullable: true },
                  start_date: { type: :string, format: :date },
                  end_date: { type: :string, format: :date, nullable: true },
                  occupation_id: { type: :integer, nullable: true },
                  created_at: { type: :string, example: '2020-01-01T00:00:00.000Z' },
                  updated_at: { type: :string, example: '2020-01-01T00:00:00.000Z' }
                }
              }
            }
          },
          Company: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, example: 'companies' },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string, example: 'Company name' },
                  cnpj: { type: :string, example: '01.123.456/0001-01' },
                  email: { type: :string, example: 'name@company.com' },
                  created_at: { type: :string, example: '2020-01-01T00:00:00.000Z' },
                  updated_at: { type: :string, example: '2020-01-01T00:00:00.000Z' }
                }
              }
            }
          },
          Occupation: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, example: 'occupations' },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string, example: 'Occupation name' },
                  active: { type: :boolean },
                  created_at: { type: :string, example: '2020-01-01T00:00:00.000Z' },
                  updated_at: { type: :string, example: '2020-01-01T00:00:00.000Z' }
                }
              }
            }
          }
        }
      },
      servers: [
        {
          url: 'http://localhost:3000',
          variables: {
            defaultHost: {
              default: 'http://localhost:3000'
            }
          }
        }
      ]
    }
  }
  config.swagger_format = :yaml
end
