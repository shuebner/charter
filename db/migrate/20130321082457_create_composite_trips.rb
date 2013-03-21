class CreateCompositeTrips < ActiveRecord::Migration
  def change
    create_table :composite_trips do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.references :boat
      t.boolean :active

      t.timestamps
    end
    add_index :composite_trips, [:slug, :active]
    add_index :composite_trips, [:boat_id, :active]
  end
end
