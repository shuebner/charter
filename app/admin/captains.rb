# encoding: utf-8
ActiveAdmin.register Captain do
  config.filters = false
  config.sort_order = "last_name_asc"
  
  index do
    column :first_name
    column :last_name
    column :phone_mobile
    default_actions
  end

  show title: :full_name do |c|
    attributes_table_for c do
      row(:image) do 
        if c.image
          image_tag(c.image.thumb('200x200').url)
        else
          I18n.t('no_picture_available')
        end
      end
      row :first_name
      row :last_name
      row :sailing_certificates
      row :additional_certificates
      row :phone_mobile
      row :email
      row :description
    end
  end

  form html: { enctype: "mulitpart/form-data" } do |f|
    f.inputs "Person" do
      f.input :first_name
      f.input :last_name
      f.input :description

      unless f.object.image
        f.object.build_image
      end

      f.inputs for: :image, name: "Portrait" do |i|
        if !i.object.nil?
          i.input :_destroy, as: :boolean, label: "Bild löschen"
        end
        i.input :order, as: :hidden, value: 1
        i.input :attachment_title
        i.input :attachment, as: :file,
          hint: i.object.attachment.nil? ?
            i.template.content_tag(:span, I18n.t('no_picture_available')) :
            i.template.image_tag(i.object.attachment.thumb('200x200').url)
        i.input :retained_attachment, as: :hidden
      end
    end

    f.inputs "Fähigkeiten" do
      f.input :sailing_certificates
      f.input :additional_certificates
    end

    f.inputs "Kontakt" do
      f.input :phone_mobile
      f.input :email
    end

    f.actions
  end
end
