class ChangeTripBookingsForUseOfCustomerNumbers < ActiveRecord::Migration
  def up
    add_column :trip_bookings, :customer_number, :integer
    TripBooking.all.each do |b|
      b.customer_number = Customer.find_by_id(b.customer_id).number
      b.save! validate: false
    end
    remove_column :trip_bookings, :customer_id
    add_index :trip_bookings, :customer_number    
  end

  def down
    add_column :trip_bookings, :customer_id, :integer
    TripBooking.all.each do |b|
      b.customer_id = Customer.find_by_number(b.customer_number).id
      b.save! validate: false
    end
    remove_column :trip_bookings, :customer_number
    add_index :trip_bookings, :customer_id
  end
end
