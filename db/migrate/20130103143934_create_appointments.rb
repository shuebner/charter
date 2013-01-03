class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.string :type

      t.timestamps
    end
  end
end
