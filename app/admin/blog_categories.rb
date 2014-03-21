# encoding: utf-8

ActiveAdmin.register BlogCategory do
  menu parent: I18n.t('blog')

  config.filters = false
  config.sort_order = 'name_asc'

  index do
    column :name
    default_actions
  end

  show title: :name do |c|
    attributes_table do
      row :name
      row :created_at
      row :updated_at
    end
    panel t("activerecord.models.blog_entry.other") do
      table_for c.blog_entries, i18n: BlogEntry do
        column(:heading) do |e|
          link_to e.heading, admin_blog_entry_path(e)
        end
        column :updated_at
        column(:active) do |e|
          status_tag (e.active? ? "ja" : "nein"), (e.active? ? :ok : :error)
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end