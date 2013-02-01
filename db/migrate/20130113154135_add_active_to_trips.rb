class AddActiveToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :active, :boolean
    execute "UPDATE trips SET active = TRUE WHERE active IS NULL"
    add_index :trips, [:active], name: "index_trips_visibility"
  end
end
