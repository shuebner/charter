# encoding: utf-8
ActiveAdmin.register TripBooking do
  menu parent: I18n.t('bookings')
  
  filter :number
  filter :created_at
  filter :customer

  scope :all do |bookings|
    bookings.includes [:customer]
  end

  scope :effective, default: true do |bookings|
    bookings.effective.includes [:customer]
  end

  actions :all, except: [:destroy]

  member_action :cancel, method: :put do
    booking = TripBooking.find(params[:id])
    if booking.cancelled?
      redirect_to admin_trip_booking_path(booking), 
        alert: "Buchung #{booking.number} wurde bereits am " \
                "#{I18n.l(booking.cancelled_at)} storniert"
    else
      booking.cancel!
      booking.save
      redirect_to admin_trip_booking_path(booking),
        notice: "Buchung #{booking.number} wurde erfolgreich storniert"
    end
  end

  action_item only: :show, if: Proc.new { !trip_booking.cancelled? } do
    button_to "stornieren", cancel_admin_trip_booking_path, method: :put, 
      confirm: "Eine Stornierung kann nicht rückgängig gemacht werden!\n" \
               "Buchung #{trip_booking.number} wirklich stornieren?"
  end

  index do
    column :number
    column(Boat.model_name.human) { |b| b.trip.boat.name }
    column :trip, sortable: false
    column :customer, sortable: 'customers.last_name'
    column :no_of_bunks
    column :created_at
    column() do |b|
      if !b.cancelled?
        link_to "stornieren", cancel_admin_trip_booking_path(b), method: :put, 
          confirm: "Eine Stornierung kann nicht rückgängig gemacht werden!\n" \
                   "Buchung #{b.number} wirklich stornieren?"
      end
    end
    column "" do |b|
      link_to I18n.t('active_admin.view'), admin_boat_booking_path(b)
    end
    column "" do |b|
      b.cancelled? ? '' : 
        link_to(I18n.t('active_admin.edit'), edit_admin_boat_booking_path(b))
    end
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
      options = { 
        false => { input_html: { disabled: true } },
        true => {} }[f.object.new_record?]
      f.input :customer, options.merge(collection: Customer.by_name.map{ |c| [c.display_name, c.number] })
      f.input :trip_date, options.merge(collection: TripDate.all.map{ |d| [d.display_name_with_trip, d.id] })
      f.input :no_of_bunks, as: :select, collection: 1..6
    end
    f.actions
  end
end
