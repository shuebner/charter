class AddActiveToBoats < ActiveRecord::Migration
  def change
    add_column :boats, :active, :boolean
    execute "UPDATE boats SET active = TRUE WHERE active IS NULL"
    add_index :boats, [:available_for_boat_charter, :available_for_bunk_charter, :active], name: "index_boats_visibility"
  end
end
