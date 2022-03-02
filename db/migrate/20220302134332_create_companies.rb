class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :name
      t.string :cnpj
      t.string :email

      t.timestamps
    end
    add_index :companies, :cnpj, unique: true
    add_index :companies, :email, unique: true
  end
end
