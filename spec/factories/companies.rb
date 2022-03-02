FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    cnpj { Faker::Company.brazilian_company_number(formatted: true) }
    email { Faker::Internet.email }
  end
end
