class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.string :url
      t.integer :order

      t.timestamps
    end
    add_index :partners, :order
  end
end
