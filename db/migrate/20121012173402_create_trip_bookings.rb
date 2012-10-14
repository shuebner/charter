class CreateTripBookings < ActiveRecord::Migration
  def change
    create_table :trip_bookings do |t|
      t.references :trip_date, null: false
      t.references :customer, null: false
      t.string :number, unique: true
      t.string :slug, unique: true
      t.integer :no_of_bunks
      t.datetime :cancelled_at

      t.timestamps
    end
    add_index :trip_bookings, :slug, unique: true
    add_index :trip_bookings, :number, unique: true
    add_index :trip_bookings, :trip_date_id
    add_index :trip_bookings, :customer_id
  end
end
