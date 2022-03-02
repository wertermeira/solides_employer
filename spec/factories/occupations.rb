FactoryBot.define do
  factory :occupation do
    name { Faker::Job.title }
    active { true }
    company { create(:company) }
  end
end
