class CreateBoatInquiries < ActiveRecord::Migration
  def up
    create_table :boat_inquiries do |t|
      t.references :boat, null: false
      t.date :begin_date, null: false
      t.date :end_date, null: false
      t.integer :adults, null: false
      t.integer :children
    end
    create_citier_view(BoatInquiry)
  end

  def down
    drop_citier_view(BoatInquiry)
    drop_table :boat_inquiries
  end
end
