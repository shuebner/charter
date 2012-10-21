ActiveAdmin.register Season do
  config.filters = false
  config.sort_order = 'begin_date_asc'

  index do
    column :name
    column :begin_date
    column :end_date
    default_actions
  end

  show title: :name do |s|
    attributes_table do
      row :name
      row :begin_date
      row :end_date
    end
  end

  form do |f|
    f.inputs :name, :begin_date, :end_date
    f.buttons
  end
end
