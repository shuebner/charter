class RenameCustomerIdToCustomerNumberInBoatBookings < ActiveRecord::Migration
  def change
    rename_column :boat_bookings, :customer_id, :customer_number
  end
end
