class AddDeferredToTripDate < ActiveRecord::Migration
  def up
    add_column :trip_dates, :deferred, :boolean
    drop_citier_view(TripDate)
    create_citier_view(TripDate)
    execute("UPDATE trip_dates SET deferred = FALSE")
  end

  def down
    remove_column :trip_dates, :deferred
    drop_citier_view(TripDate)
    create_citier_view(TripDate)
  end    
end
