class MakeTripDateSubclassOfAppointment < ActiveRecord::Migration
  def up
#=begin
    dates = execute(
      "SELECT id, trip_id, begin_date, end_date, created_at, updated_at "\
      "FROM trip_dates")

    dates.each do |d|
      # insert data for new appointment
      execute(
        "INSERT INTO appointments "\
        "(type, start_at, end_at, created_at, updated_at) "\
        "VALUES ('TripDate', '#{d[2]}', '#{d[3]}', '#{d[4]}', '#{d[5]}')")
      
      # retrieve the id for the newly inserted appointment
      id = execute(
        "SELECT id FROM appointments "\
        "WHERE type = 'TripDate' AND start_at = '#{d[2]}' AND "\
          "end_at = '#{d[3]}' AND created_at = '#{d[4]}' AND "\
          "updated_at = '#{d[5]}'").first[0]
#=end
=begin      
      # there should be exactly one entry equal to d
      if id.is_a?(Array)
        message = "duplicate entry for TripDate in appointments with "
        message << "start_at = #{d[2]}, end_at = #{d[3]}, "
        message << "created_at = #{d[4]}, updated_at = #{d[5]}"
        raise message
      end
=end
#=begin
      # remember the new id for the TripDate
      d[6] = id
    end

    # delete now unnecessary columns
    [:begin_date, :end_date, :created_at, :updated_at].each do |c|
      remove_column :trip_dates, c
    end

    # delete every entry in trip_dates
    execute("DELETE FROM trip_dates")

    # insert the old trip dates with their new ids
    # remember the trip bookings and trip inquiries for each one
    trip_booking_ids = Hash.new
    trip_inquiry_ids = Hash.new
    dates.each do |d|
      execute(
        "INSERT INTO trip_dates (id, trip_id) "\
        "VALUES (#{d[6]}, #{d[1]})")
      
      # update the trip_date_id in trip_inquiries and trip_bookings
      # THIS CODE IS WRONG!!!
=begin
      ['trip_inquiries', 'trip_bookings'].each do |table|
        execute(
          "UPDATE #{table} "\
          "SET trip_date_id = #{d[6]} "\
          "WHERE trip_date_id = #{d[0]}")
      end
=end
      # THIS IS THE RIGHT CODE
      # just remember the corresponding trip bookings and trip inquiries for later
      trip_booking_ids[d[0]] = execute("SELECT id FROM trip_bookings WHERE trip_date_id = #{d[0]}").to_a.flatten
      trip_inquiry_ids[d[0]] = execute("SELECT id FROM trip_inquiries WHERE trip_date_id = #{d[0]}").to_a.flatten
      
    end

    # now update with the remembered old ids
    trip_booking_ids.each do |date_id, trip_booking_ids|
      execute("UPDATE trip_bookings SET trip_date_id = #{date_id} WHERE id IN (#{trip_booking_ids.join('-')})")
    end

    trip_inquiry_ids.each do |date_id, trip_inquiry_ids|
      execute("UPDATE trip_inquiries SET trip_date_id = #{date_id} WHERE id IN (#{trip_inquiry_id.join('-')})")
    end
    create_citier_view(TripDate)
  end

  def down
    drop_citier_view(TripDate)

    [:begin_date, :end_date, :created_at, :updated_at].each do |c|
      add_column :trip_dates, c, :datetime
    end

    appointments = execute(
      "SELECT id, start_at, end_at, created_at, updated_at "\
      "FROM appointments WHERE type = 'TripDate'")

    appointments.each do |a|
      execute(
        "UPDATE trip_dates "\
        "SET begin_date = '#{a[1]}', end_date = '#{a[2]}', "\
          "created_at = '#{a[3]}', updated_at = '#{a[4]}' "\
        "WHERE id = #{a[0]}")
      execute "DELETE from appointments WHERE id = #{a[0]}"
    end
  end
end
