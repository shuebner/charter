ActiveAdmin.register TripDate do
  menu parent: I18n.t("trip_data")

  config.sort_order = 'start_at'
  filter :trip
  filter :start_at
  filter :end_at

  index do
    column :trip
    column :start_at
    column :end_at
    default_actions
  end

  show title: :display_name_with_trip do |td|
    attributes_table do
      row :trip
      row :start_at
      row :end_at
    end
  end

  form do |f|
    f.inputs do
      f.input :start_at
      f.input :end_at
    end
    f.actions
  end
end
