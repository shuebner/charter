class AllowNullOnYearOfConstructionInBoat < ActiveRecord::Migration
  def up
    change_column :boats, :year_of_construction, :integer, null: true
  end

  def down
    change_column :boats, :year_of_construction, :integer, null: false
  end
end
