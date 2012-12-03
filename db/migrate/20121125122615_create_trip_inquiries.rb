class CreateTripInquiries < ActiveRecord::Migration
  def up
    create_table :trip_inquiries do |t|
      t.references :trip_date, null: false
      t.integer :bunks, null: false
    end
    create_citier_view(TripInquiry)
  end

  def down
    drop_citier_view(TripInquiry)
    drop_table :trip_inquiries
  end
end
