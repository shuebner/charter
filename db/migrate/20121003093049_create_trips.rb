class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|

      t.references :boat, null: false
      t.string :name, null: false
      t.string :slug, null: false, unique: true
      t.text :description, null: false
      t.integer :no_of_bunks, null: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.timestamps
    end
    add_index :trips, :boat_id
    add_index :trips, :slug, unique: true
  end
end
