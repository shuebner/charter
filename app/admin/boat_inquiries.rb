ActiveAdmin.register BoatInquiry do
  menu parent: I18n.t("activerecord.models.inquiry.other")

  config.sort_order = 'created_at_desc'

  filter :last_name
  filter :email
  filter :created_at
  filter :boat

  scope :all, default: true do |i|
    i.includes(:boat)
  end
  
  actions :all, except: [:new, :edit]

  index do
    column :created_at
    column :boat, sortable: "boats.name"
    column :begin_date
    column :end_date
    column :full_name, sortable: :last_name
    column :email
    default_actions
  end

  show do |i|
    attributes_table_for i do
      row :created_at
      row :boat
      row :begin_date
      row :end_date
      row :adults
      row :children
      row :people
      row :first_name
      row :last_name
      row :email
      row :text
    end
  end
end
