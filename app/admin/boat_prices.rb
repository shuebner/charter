ActiveAdmin.register BoatPrice do
  config.filters = false
  config.sort_order = "boat_asc season_asc boat_price_type_asc"

  index do
    column :boat
    column :season
    column :boat_price_type
    column(:value) { |p| number_to_currency(p.value) }
    default_actions
  end

  show do |p|
    attributes_table do
      row :boat
      row :season
      row :boat_price_type
      row(:value) { number_to_currency(p.value) }
    end
  end

  form do |f|
    f.inputs do
      f.input :boat, collection: Boat.boat_charter_only
      f.input :season
      f.input :boat_price_type
      f.input :value
    end
    f.buttons
  end
end
