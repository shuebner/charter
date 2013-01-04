ActiveAdmin.register BoatBooking do
  menu parent: I18n.t('bookings')

  filter :number
  filter :created_at
  filter :customer
  filter :boat

  actions :all, except: [:edit, :destroy]

  scope :all, default: true do |bookings|
    bookings.includes [:customer]
    bookings.includes [:customer]
  end

  index do
    column :number
    column(Boat.model_name.human) { |b| b.boat.name }
    column :customer
    column :start_at
    column :end_at
    column :people
    default_actions
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
    end
  end

  form do |f|
    f.inputs do
      f.input :customer, collection: Customer.by_name.map{ |c| [c.display_name, c.number] }
      f.input :boat, collection: Boat.boat_charter_only.map{ |b| [b.name, b.id] }
      f.input :start_at
      f.input :end_at
      f.input :adults, as: :select, collection: 1..6
      f.input :children, as: :select, collection: 0..6
    end
    f.actions
  end
end
