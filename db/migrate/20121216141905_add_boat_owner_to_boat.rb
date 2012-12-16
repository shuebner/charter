class AddBoatOwnerToBoat < ActiveRecord::Migration
  def up
    add_column :boats, :boat_owner_id, :integer, null: false
    add_index :boats, :boat_owner_id
    owner = BoatOwner.first
    if owner.nil?
      owner = BoatOwner.create!(name: "Palve-Charter", is_self: true)
    end

    Boat.all.each do |b|
      b.boat_owner_id = owner.id
      b.save!
    end
  end

  def down
    remove_column :boats, :boat_owner_id
  end
end
