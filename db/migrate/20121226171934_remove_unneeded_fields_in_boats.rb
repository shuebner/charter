class RemoveUnneededFieldsInBoats < ActiveRecord::Migration
  def up
    remove_column :boats, :engine_manufacturer
    remove_column :boats, :engine_design
  end

  def down
    add_column :boats, :engine_manufacturer, :string
    add_column :boats, :engine_design, :string
  end
end
