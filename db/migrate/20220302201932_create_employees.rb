class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :occupation, null: true, foreign_key: true, type: :uuid
      t.string :name
      t.string :cpf
      t.string :email
      t.string :phone_number
      t.date :start_date
      t.date :end_date
      t.decimal :montly_salary, precision: 10, scale: 2

      t.timestamps
    end
    add_index :employees, :cpf, unique: true
    add_index :employees, :email, unique: true
  end
end
