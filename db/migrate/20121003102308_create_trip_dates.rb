class CreateTripDates < ActiveRecord::Migration
  def change
    create_table :trip_dates do |t|
      t.references :trip, null: false
      t.datetime :begin, null: false
      t.datetime :end, null: false

      t.timestamps
    end
    add_index :trip_dates, :trip_id
    add_index :trip_dates, :begin
  end
end
