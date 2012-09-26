class CreateBoats < ActiveRecord::Migration
  def change
    create_table :boats do |t|
      linear = { precision: 5, scale: 3 }
      area = { precision: 5, scale: 2 }
      mass = { precision: 5, scale: 3 }
      money = { precision: 7, scale: 2 }

      t.string :manufacturer, null: false
      t.string :model, null: false
      
      t.decimal :length_hull, linear
      t.decimal :length_waterline, linear
      t.decimal :beam, linear
      t.decimal :draft, linear
      t.decimal :air_draft, linear
      t.decimal :displacement, mass
      
      t.decimal :sail_area_jib, area
      t.decimal :sail_area_genoa, area
      t.decimal :sail_area_main_sail, area
      
      t.integer :tank_volume_diesel
      t.integer :tank_volume_fresh_water
      t.integer :tank_volume_waste_water
      
      t.integer :permanent_bunks
      t.integer :convertible_bunks
      t.integer :max_no_of_people
      t.integer :recommended_no_of_people
      
      t.decimal :headroom_saloon, linear
      
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

      t.decimal :deposit, money
      t.decimal :cleaning_charge, money
      t.decimal :fuel_charge, money
      t.decimal :gas_charge, money

      t.timestamps
    end
    add_index :boats, :slug
  end
end
