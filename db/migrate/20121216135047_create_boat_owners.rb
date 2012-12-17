class CreateBoatOwners < ActiveRecord::Migration
  def change
    create_table :boat_owners do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.boolean :is_self, null: false

      t.timestamps
    end
    add_index :boat_owners, :slug, unique: true
  end
end
