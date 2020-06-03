class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :code
      t.integer :category
      t.decimal :price
      t.jsonb :discount_rules

      t.timestamps
    end
  end
end
