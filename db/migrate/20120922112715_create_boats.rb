class CreateBoats < ActiveRecord::Migration
  def change
    create_table :boats do |t|
      money = { precision: 5, scale: 2 }

      t.references :boat_type, null: false
      
      t.string :name, null: false
      t.string :slug, null: false, unique: true
      
      t.integer :year_of_construction, null: false
      t.integer :year_of_refit
      
      t.string :engine_manufacturer
      t.string :engine_model
      t.string :engine_design
      t.integer :engine_output      
      
      t.integer :battery_capacity
      
      t.boolean :available_for_boat_charter, null: false
      t.boolean :available_for_bunk_charter, null: false

      t.decimal :deposit, precision: 6, scale: 2
      t.decimal :cleaning_charge, money
      t.decimal :fuel_charge, money
      t.decimal :gas_charge, money

      t.timestamps
    end
    add_index :boats, :boat_type_id
    add_index :boats, :slug
  end
end
