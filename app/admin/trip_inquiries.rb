ActiveAdmin.register TripInquiry do
  menu parent: I18n.t("activerecord.models.inquiry.other")

  config.sort_order = 'created_at_desc'

  filter :last_name
  filter :email
  filter :created_at
  
  actions :all, except: [:new, :edit]

  index do
    column :created_at
    column(:trip_date) { |i| i.trip_date.display_name_with_trip }
    column :full_name
    column :email
    default_actions
  end

  show do |i|
    attributes_table_for i do
      row :created_at
      row :trip_date
      row :bunks
      row :first_name
      row :last_name
      row :email
      row :text
    end
  end
end
