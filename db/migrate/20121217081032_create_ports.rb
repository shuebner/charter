class CreatePorts < ActiveRecord::Migration
  def change
    create_table :ports do |t|
      t.string :name, null: false
      t.string :slug, null: false, unique: true

      t.timestamps
    end
    add_index :ports, :slug, unique: true
  end
end
