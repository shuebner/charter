class CreateBoatBookings < ActiveRecord::Migration
  def change
    create_table :boat_bookings do |t|
      t.references :customer, null: false
      t.references :boat, null: false
      t.string :number, null: false, unique: true
      t.string :slug, null: false, unique: true
      t.datetime :begin_date, null: false
      t.datetime :end_date, null: false
      t.integer :adults, null: false
      t.integer :children, null: false

      t.timestamps
    end
    add_index :boat_bookings, :slug, uniqeness: true
    add_index :boat_bookings, :number, uniqueness: true
  end
end
