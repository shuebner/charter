# encoding: utf-8

ActiveAdmin.register Partner do
  config.filters = false
  config.sort_order = 'order_asc'

  index do
    column :order
    column :name
    column :url
    column :image do |p|
      p.image.nil? ? I18n.t('no_picture_available') :
        image_tag(p.image.thumb('120x120').url)
    end
    default_actions
  end

  show title: :name do |p|
    panel t("activerecord.models.partner.one") do
      attributes_table_for p do
        row :order
        row :name
        row :url
      end
    end

    panel t("activerecord.models.partner_image.one") do
      attributes_table_for p.image do      
        row :attachment_title
        row "Bild" do |image|
          image.nil? ? I18n.t('no_picture_available') :
            image_tag(image.thumb('200x200').url)
        end
      end
    end
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs I18n.t('activerecord.models.partner.one'), multipart: true do
      f.input :order
      f.input :name
      f.input :url
    end
    f.inputs I18n.t('activerecord.models.partner_image.one'), for: [:image, f.object.image || f.object.build_image] do |imagef|
      imagef.input :_destroy, as: :boolean, label: "kein Bild verwenden"
      imagef.input :attachment_title
      imagef.input :attachment, as: :file,
        hint: imagef.object.attachment.nil? ? 
          imagef.template.content_tag(:span, I18n.t('no_picture_available')) :
          imagef.template.image_tag(imagef.object.thumb('200x200').url)
      imagef.input :retained_attachment, as: :hidden
    end
    f.actions
  end
end
