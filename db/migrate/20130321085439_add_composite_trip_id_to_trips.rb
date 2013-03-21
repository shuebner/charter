class AddCompositeTripIdToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :composite_trip_id, :integer
    add_index :trips, :composite_trip_id
  end
end
