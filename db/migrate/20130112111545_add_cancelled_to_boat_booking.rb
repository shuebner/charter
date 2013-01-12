class AddCancelledToBoatBooking < ActiveRecord::Migration
  def change
    add_column :boat_bookings, :cancelled, :boolean
    execute "UPDATE boat_bookings SET cancelled = FALSE WHERE cancelled IS NULL"
    add_index :boat_bookings, :cancelled
  end
end
