class CreateBoatPrices < ActiveRecord::Migration
  def change
    create_table :boat_prices do |t|
      t.decimal :value, precision: 7, scale: 2, null: false
      t.references :boat_price_type, null: false
      t.references :season, null: false
      t.references :boat, null: false

      t.timestamps
    end
    add_index :boat_prices, :boat_price_type_id
    add_index :boat_prices, :season_id
    add_index :boat_prices, :boat_id
  end
end
