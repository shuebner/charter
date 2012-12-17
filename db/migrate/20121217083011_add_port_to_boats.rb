# encoding: utf-8
class AddPortToBoats < ActiveRecord::Migration
  def up
    add_column :boats, :port_id, :integer, null: false    
    add_index :boats, :port_id

    port = Port.first
    if port.nil?
      port = Port.new(name: "Kröslin")
      port.save!
    end
    Boat.all.each do |b|
      b.port_id = port.id
      b.save!
    end
  end

  def down
    remove_column :boats, :port_id
  end
end
