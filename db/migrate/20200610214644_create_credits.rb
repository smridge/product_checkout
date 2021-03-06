class CreateCredits < ActiveRecord::Migration[6.0]
  def change
    create_table :credits do |t|
      t.integer :product_type
      t.integer :units
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
