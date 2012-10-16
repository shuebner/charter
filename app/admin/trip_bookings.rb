ActiveAdmin.register TripBooking do
  filter :number
  filter :created_at
  filter :customer

  actions :all, except: [:edit]

  index do
    column :number
    column(Boat.model_name.human) { |b| b.trip.boat.name }
    column :trip
    column :customer
    column :no_of_bunks
    column :created_at
    default_actions
  end

  show title: :number do |b|
    attributes_table do
      row :number
      row :created_at
      row :customer
      row :trip
      row :trip_date
      row :no_of_bunks
      row("Storniert") { b.cancelled_at }
    end
  end

  form do |f|
    f.inputs do
      f.input :customer
      f.input :trip_date, collection: TripDate.all.map{ |d| [d.display_name_with_trip, d.id] }
      f.input :no_of_bunks, as: :select, collection: 1..6
    end
    f.buttons
  end
end
