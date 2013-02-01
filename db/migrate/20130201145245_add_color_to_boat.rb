class AddColorToBoat < ActiveRecord::Migration
  def up
    add_column :boats, :color, :string
    execute "UPDATE boats SET color='#c0c0c0'"
  end

  def down
    remove_column :boats, :color
  end
end
