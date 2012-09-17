ActiveAdmin.register StaticPage do
  config.filters = false
  config.sort_order = "heading_asc"
  actions :all, except: [:destroy]

  index do
    column :heading
    column :text
    column :created_at
    column :updated_at
    default_actions
  end

  show title: :title do |page|
    attributes_table do 
      row :heading
      row :text
      row :picture do
        page.picture.nil? ? I18n.t('no_picture_available') :
          image_tag(page.picture.thumb('200x200').url)
      end
      row :picture_name do
        page.picture.nil? ? I18n.t('no_picture_available') :
          page.picture_name
      end
      unless page.paragraphs.empty?
        table_for page.paragraphs do
          column :heading do |paragraph|
            paragraph.heading
          end
          column :text do |paragraph|
            paragraph.text
          end
        end
      end
    end
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs I18n.t('activerecord.models.static_page.one'), multipart: true do
      f.input :heading
      f.input :text
      f.input :picture_name
      f.input :picture, as: :file, hint: 
        f.object.picture.nil? ? f.template.content_tag(:span, I18n.t('no_picture_available')) : 
          f.template.image_tag(f.object.picture.thumb('200x200').url)
      f.input :remove_picture, as: :boolean
    end

    f.has_many :paragraphs do |p|
      p.inputs I18n.t('activerecord.models.paragraph.one') do
        if !p.object.nil?
          p.input :_destroy, as: :boolean, label: I18n.t('delete_paragraph_question')
        end

        p.input :order
        p.input :heading
        p.input :text
      end
    end
    f.buttons
  end
end
