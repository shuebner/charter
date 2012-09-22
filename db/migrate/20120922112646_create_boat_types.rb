class CreateBoatTypes < ActiveRecord::Migration
  def change
    create_table :boat_types do |t|
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

      t.timestamps
    end    
    add_index :boat_types, [:manufacturer, :model], unique: true
  end
end
