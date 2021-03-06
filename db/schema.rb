# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_02_201932) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_companies_on_cnpj", unique: true
    t.index ["email"], name: "index_companies_on_email", unique: true
  end

  create_table "employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "occupation_id"
    t.string "name"
    t.string "cpf"
    t.string "email"
    t.string "phone_number"
    t.date "start_date"
    t.date "end_date"
    t.decimal "montly_salary", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["cpf"], name: "index_employees_on_cpf", unique: true
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["occupation_id"], name: "index_employees_on_occupation_id"
  end

  create_table "occupations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.uuid "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_occupations_on_company_id"
  end

  add_foreign_key "employees", "companies"
  add_foreign_key "employees", "occupations"
  add_foreign_key "occupations", "companies"
end
