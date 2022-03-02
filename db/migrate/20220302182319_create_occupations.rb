class CreateOccupations < ActiveRecord::Migration[7.0]
  def change
    create_table :occupations, id: :uuid do |t|
      t.string :name
      t.boolean :active
      t.references :company, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
