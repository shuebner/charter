ActiveAdmin.register BoatPriceType do
  menu parent: I18n.t("boat_data")

  config.filters = false
  config.sort_order = "duration_asc name_asc"

  index do
    column :duration
    column :name
    default_actions
  end

  show title: :name do |t|
    attributes_table do
      row :name
      row :duration
    end
  end

  form do |f|
    f.inputs :name, :duration
    f.actions
  end
end
