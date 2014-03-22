ActiveAdmin.register BlogEntryComment do
  menu parent: I18n.t('blog')

  filter :blog_entry
  filter :blog_entry_blog_category_slug, label: I18n.t("activerecord.models.blog_category.one"),
    as: :select, collection: Proc.new { BlogCategory.all.map { |c| [c.name, c.slug] } }
  filter :created_at

  config.sort_order = 'created_at_desc'

  scope :all do |comments|
    comments.includes [{ entry: :category }]
  end

  index do
    column :category, sortable: 'blog_category.name'
    column :entry, sortable: 'blog_entry.heading'
    column :author
    column :created_at
    default_actions
  end

  show title: :author do |c|
    attributes_table do
      row :category
      row :entry
      row :author
      row :created_at
      row :updated_at
      row :text
    end
  end

  form do |f|
    f.inputs do
      f.input :author
      f.input :text
    end
    f.actions
  end
end