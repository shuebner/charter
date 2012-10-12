# encoding: utf-8
ActiveAdmin.register Trip do
  config.filters = false
  config.sort_order = 'name_asc'

  index do
    column :name
    column :no_of_bunks
    column(:price) { |t| number_to_currency(t.price) }
    column(Boat.model_name.human) { |t| t.boat.name }
    default_actions
  end

  show title: :name do |t|
    attributes_table do
      row :name
      row :no_of_bunks
      row(:price) { number_to_currency(t.price) }
      row :description
      row(Boat.model_name.human) { t.boat.name }
    end
    panel "Termine" do
      table_for t.trip_dates, i18n: TripDate do
        column :begin
        column :end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :no_of_bunks
      f.input :price
      f.input :description
      f.input :boat, collection: Boat.bunk_charter_only
    end
    
    f.has_many :trip_dates do |td|
      td.inputs do
        if !td.object.nil?
          td.input :_destroy, as: :boolean, label: "Termin löschen"
        end
      end
      td.inputs do
        td.input :begin
        td.input :end
      end
    end
    f.buttons
  end
end
