class AddPortToBoats < ActiveRecord::Migration
  def up
    add_column :boats, :port_id, :integer, null: false    
    add_index :boats, :port_id
  end

  def down
    remove_column :boats, :port_id
  end
end
