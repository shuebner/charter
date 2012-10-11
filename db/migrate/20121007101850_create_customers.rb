class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.boolean :is_male, null: false
      t.string :phone_landline
      t.string :phone_mobile
      t.string :email
      t.string :street_name
      t.string :street_number
      t.string :zip_code
      t.string :city
      t.string :country

      t.timestamps
    end
    add_index :customers, :last_name
    add_index :customers, :first_name
  end
end
