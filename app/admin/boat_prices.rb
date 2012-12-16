ActiveAdmin.register BoatPrice do
  filter :boat
  filter :season
  filter :boat_price_type

  config.sort_order = "boats.name_asc"

  scope :all, default: true do |prices|
    prices.includes [:boat, :season, :boat_price_type]
  end

  index do
    column :boat, sortable: "boats.name"
    column :season, sortable: "seasons.name"
    column :boat_price_type, sortable: "boat_price_types.name"
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
    f.actions
  end
end
