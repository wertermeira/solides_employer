namespace :populate do
  include FactoryBot::Syntax::Methods if Rails.env.development?

  desc 'Populate the database with fake data'
  task all: :environment do
    puts 'Populating the database with fake data...'
    puts '----------------------------------------------------'
    10.times do
      puts 'Creating a new company...'
      create(:company).tap do |company|
        puts "Created company: #{company.name}"
        puts '----------------------------------------------------'
        puts 'Creating occupations...'
        create_list(:occupation, rand(1..10), company: company).each do |occupation|
          puts "Created occupation: #{occupation.name}"
        end
        puts '----------------------------------------------------'
        puts 'Creating employees...'
        create_list(:employee, rand(1..30), company: company, occupation: company.occupations.sample).each do |employee|
          puts "Created employee: #{employee.name}"
        end
      end
    end
    puts '----------------------------------------------------'
    puts 'Done!'
  end
end
