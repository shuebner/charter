# encoding: utf-8
ActiveAdmin.register BoatBooking do
  menu parent: I18n.t('bookings')

  filter :number
  filter :created_at
  filter :customer
  filter :boat

  scope :all do |bookings|
    bookings.includes [:customer]
  end

  scope :effective, default: true do |bookings|
    bookings.effective.includes [:customer]
  end

  actions :all, except: [:destroy]

  member_action :cancel, method: :put do
    booking = BoatBooking.find(params[:id])
    if booking.cancelled?
      redirect_to admin_boat_booking_path(booking), 
        alert: "Buchung #{booking.number} ist bereits storniert"
    else
      booking.cancel!
      booking.save!
      redirect_to admin_boat_booking_path(booking),
        notice: "Buchung #{booking.number} wurde erfolgreich storniert"
    end
  end

  action_item only: :show, if: Proc.new { !boat_booking.cancelled? } do
    button_to "stornieren", cancel_admin_boat_booking_path, method: :put, 
      confirm: "Eine Stornierung kann nicht rückgängig gemacht werden!\n" \
               "Buchung #{boat_booking.number} wirklich stornieren?"
  end

  index do
    column :number
    column(Boat.model_name.human) { |b| b.boat.name }
    column :customer
    column :start_at
    column :end_at
    column :people
    column() do |b|
      if !b.cancelled?
        link_to "stornieren", cancel_admin_boat_booking_path(b), method: :put, 
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
      row :boat
      row :start_at
      row :end_at
      row :adults
      row :children
      row :people
      row :cancelled? do |b|
        status_tag (b.cancelled? ? "ja" : "nein"),
          (b.cancelled? ? :error : :ok)
      end
    end
  end

  form do |f|
    f.inputs do
      options = { 
        false => { input_html: { disabled: true } },
        true => {} }[f.object.new_record?]
      f.input :customer, options.merge(collection: Customer.by_name.map{ |c| [c.display_name, c.number] })
      f.input :boat, options.merge(collection: Boat.boat_charter_only.map{ |b| [b.name, b.id] })
      f.input :start_at
      f.input :end_at
      f.input :adults, as: :select, collection: 1..6
      f.input :children, as: :select, collection: 0..6
    end
    f.actions
  end
end
