# encoding: utf-8
ActiveAdmin.register Captain do
  config.filters = false
  config.sort_order = "last_name_asc"
  
  index do
    column :first_name
    column :last_name
    column :phone_mobile
  end

  show do
    row :first_name
    row :last_name
    row :sailing_certificates
    row :additional_certificates
    row :phone_mobile
    row :email
    row :description
  end

  form do |f|
    f.inputs "Person" do
      f.input :first_name
      f.input :last_name
      f.input :description
    end

    f.inputs "Fähigkeiten" do
      f.input :sailing_certificates
      f.input :additional_certificates
    end

    f.inputs "Kontakt" do
      f.input :phone_mobile
      f.input :email
    end
  end
end
