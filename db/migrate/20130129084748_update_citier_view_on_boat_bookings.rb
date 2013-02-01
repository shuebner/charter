class UpdateCitierViewOnBoatBookings < ActiveRecord::Migration
  def up
    drop_citier_view(BoatBooking)
    create_citier_view(BoatBooking)
    BoatBooking.reset_column_information()
  end

  def down
  end
end
