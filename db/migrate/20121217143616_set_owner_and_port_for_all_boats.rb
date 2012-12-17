# encoding: utf-8
class SetOwnerAndPortForAllBoats < ActiveRecord::Migration
  def up
    owner = BoatOwner.first
    if owner.nil?
      owner = BoatOwner.create!(name: "Palve-Charter", is_self: true)
    end

    port = Port.first
    if port.nil?
      port = Port.new(name: "Kröslin")
      port.save!
    end

    Boat.all.each do |b|
      b.boat_owner_id = owner.id
      b.port_id = port.id
      b.save!
    end    
  end

  def down
    Boat.all.each do |b|
      b.boat_owner_id = nil
      b.port_id = nil
      b.save!
    end
  end
end
