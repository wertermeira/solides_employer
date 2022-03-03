FactoryBot.define do
  factory :employee do
    company { create(:company) }
    occupation { nil }
    before :create do |employee|
      employee.occupation = create(:occupation, company: employee.company) if employee.occupation.blank?
    end
    name { Faker::Name.name }
    cpf { Faker::IDNumber.brazilian_citizen_number(formatted: true) }
    email { Faker::Internet.email }
    phone_number { '11-1111-1111' }
    start_date { Faker::Date.between(from: 2.years.ago, to: Date.today) }
    end_date { nil }
    montly_salary { '9.99' }
  end
end
