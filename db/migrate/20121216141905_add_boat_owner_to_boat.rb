class AddBoatOwnerToBoat < ActiveRecord::Migration
  def up
    add_column :boats, :boat_owner_id, :integer, null: false
    add_index :boats, :boat_owner_id
  end

  def down
    remove_column :boats, :boat_owner_id
  end
end
