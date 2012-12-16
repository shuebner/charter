ActiveAdmin.register BoatBooking do
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
    column :begin_date
    column :end_date
    column :people
    default_actions
  end

  show title: :number do |b|
    attributes_table do
      row :number
      row :created_at
      row :customer
      row :boat
      row :begin_date
      row :end_date
      row :adults
      row :children
      row :people
    end
  end

  form do |f|
    f.inputs do
      f.input :customer, collection: Customer.by_name.map{ |c| [c.display_name, c.number] }
      f.input :boat, collection: Boat.boat_charter_only.map{ |b| [b.name, b.id] }
      f.input :begin_date
      f.input :end_date
      f.input :adults, as: :select, collection: 1..6
      f.input :children, as: :select, collection: 0..6
    end
    f.actions
  end
end
