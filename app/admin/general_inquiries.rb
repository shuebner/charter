ActiveAdmin.register GeneralInquiry do
  menu parent: I18n.t("activerecord.models.inquiry.other")

  config.sort_order = 'created_at_desc'

  filter :last_name
  filter :email
  filter :created_at  
  
  actions :all, except: [:new, :edit]

  index do
    column :created_at
    column :full_name, sortable: :last_name
    column :email
    column(:text) { |i| i.text.length <= 50 ? i.text : "#{i.text.to(50)}..." }
    default_actions
  end

  show do |i|
    attributes_table_for i do
      row :created_at
      row :first_name
      row :last_name
      row :email
      row :text
    end
  end
end
