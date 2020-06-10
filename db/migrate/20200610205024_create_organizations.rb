class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :auth_token, null: false, index: { unique: true }
      t.string :slug

      t.timestamps
    end
  end
end
