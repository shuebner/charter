class RenameTripDateDateTimeColumns < ActiveRecord::Migration
  def change
    rename_column :trip_dates, :begin, :begin_date
    rename_column :trip_dates, :end, :end_date
  end
end
