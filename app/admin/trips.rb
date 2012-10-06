# encoding: utf-8
ActiveAdmin.register Trip, as: "Toern" do
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
  end

  form do |f|
    f.inputs :name, :no_of_bunks, :price, :description, :boat
    f.buttons
  end
end
