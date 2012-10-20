class CreateBoatPriceTypes < ActiveRecord::Migration
  def change
    create_table :boat_price_types do |t|
      t.string :name, null: false, unique: true
      t.integer :duration, null: false

      t.timestamps
    end
  end
end
