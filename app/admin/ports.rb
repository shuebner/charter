ActiveAdmin.register Port do
  menu parent: I18n.t("boat_data")

  config.filters = false
  config.sort_order = "name_asc"

  index do
    column :name
    column :created_at
    default_actions
  end

  show do |p|
    attributes_table_for p do
      row :name
    end
  end

  form do |f|
    f.inputs :name
    f.actions
  end
end
