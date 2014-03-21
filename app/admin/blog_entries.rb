# encoding: utf-8

ActiveAdmin.register BlogEntry do  
  menu parent: I18n.t("blog")

  filter :blog_category
  filter :created_at
  config.sort_order = 'updated_at_desc'

  member_action :activate, method: :put do
    entry = BlogEntry.find(params[:id])
    entry.activate!
    entry.save
    redirect_to admin_blog_entries_path,
      notice: "Blogeintrag #{entry.heading} wurde aktiviert"
  end

  member_action :deactivate, method: :put do
    entry = BlogEntry.find(params[:id])
    entry.deactivate!
    entry.save
    redirect_to admin_blog_entries_path,
      notice: "Blogeintrag #{entry.heading} wurde deaktiviert"
  end

  index do
    column :blog_category
    column :heading
    column :updated_at
    column :active do |e|
      status_tag (e.active? ? "ja" : "nein"), (e.active? ? :ok : :error)
    end
    column() do |e|
      if e.active?
        link_to "deaktivieren", deactivate_admin_blog_entry_path(e), method: :put,
          confirm: "Blogeintrag #{e.heading} wirklich deaktivieren?"
      else
        link_to "aktivieren", activate_admin_blog_entry_path(e), method: :put,
          confirm: "Sie haben korrekturgelesen "\
            "und möchten den Blogeintrag #{e.heading} wirklich aktivieren?"
      end
    end
    default_actions
  end

  show title: :heading do |e|
    attributes_table do
      row :blog_category
      row :heading
      row :created_at
      row :updated_at
      row :text
    end
    panel t("activerecord.models.blog_entry_image.other") do      
      table_for e.images, i18n: BlogEntryImage do
        column :order
        column :attachment_title
        column(:attachment) { |i| image_tag(i.thumb('200x200').url) }
      end
    end
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs t("blog") do
      f.input :blog_category
      f.input :heading
      f.input :text
    end

    f.has_many :images do |i|
      i.inputs do
        if !i.object.nil?
          i.input :_destroy, as: :boolean, label: "Bild löschen"
        end
        i.input :order
        i.input :attachment_title
        i.input :attachment, as: :file,
          hint: i.object.attachment.nil? ?
            i.template.content_tag(:span, I18n.t('no_picture_available')) :
            i.template.image_tag(i.object.attachment.thumb('200x200').url)
        i.input :retained_attachment, as: :hidden
      end
    end
    f.actions
  end
end