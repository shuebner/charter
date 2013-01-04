class MakeBoatBookingSubclassOfAppointment < ActiveRecord::Migration
  def up    
    bookings = execute(
      "SELECT id, begin_date, end_date, created_at, "\
      "updated_at FROM boat_bookings")
    
    inserts = []    
    bookings.each do |bb|
      inserts.push "(#{bb[0]}, 'BoatBooking', '#{bb[1]}', '#{bb[2]}', '#{bb[3]}', '#{bb[4]}')"
    end

    execute(
      "INSERT INTO appointments "\
      "(id, type, start_at, end_at, created_at, updated_at) "\
      "VALUES #{inserts.join(", ")}")

    [:begin_date, :end_date, :created_at, :updated_at].each do |c|
      remove_column :boat_bookings, c
    end

    create_citier_view(BoatBooking)
  end

  def down
    drop_citier_view(BoatBooking)
    [:begin_date, :end_date, :created_at, :updated_at].each do |c|
      add_column :boat_bookings, c, :datetime
    end
    
    appointments = execute(
      "SELECT id, start_at, end_at, created_at, updated_at "\
      "FROM appointments WHERE type = 'BoatBooking'")
    
    appointments.each do |a|
      execute(
        "UPDATE boat_bookings "\
        "SET begin_date = '#{a[1]}', end_date = '#{a[2]}', "\
          "created_at = '#{a[3]}', updated_at = '#{a[4]}' "\
        "WHERE id = #{a[0]}")
      execute "DELETE from appointments WHERE id = #{a[0]}"
    end
  end
end
