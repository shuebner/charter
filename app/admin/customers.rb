ActiveAdmin.register Customer, as: "Kunde" do
  config.sort_order = 'last_name_asc first_name_asc'
  filter :last_name
  filter :city
  filter :created_at

  index do
    column :last_name
    column :first_name
    column :street
    column :zip_code
    column :city
    column :phone_landline
    column :phone_mobile
    default_actions
  end

  show title: :full_name do |c|
    panel "Person" do
      attributes_table_for c do
        row :first_name
        row :last_name
        row :gender
      end
    end

    panel "Adresse" do
      attributes_table_for c do
        row :street_name
        row :street_number
        row :zip_code
        row :city
        row :country
      end
    end

    panel "Kontakt" do
      attributes_table_for c do
        row :phone_landline
        row :phone_mobile
        row :email
      end
    end
  end

  form do |f|
    f.inputs "Person" do
      f.input :first_name
      f.input :last_name
      f.input :gender, as: :radio, collection: ["m", "w"]
    end

    f.inputs "Adresse" do
      f.input :street_name
      f.input :street_number
      f.input :zip_code
      f.input :city
      f.input :country, as: :string
    end

    f.inputs "Kontakt" do
      f.input :phone_landline
      f.input :phone_mobile
      f.input :email
    end
    f.buttons
  end
end
