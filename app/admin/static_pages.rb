ActiveAdmin.register StaticPage, as: "Statische Seite" do
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

  show title: :title do |p|
    attributes_table do 
      row :heading
      row :text
      row :picture do
        p.picture.nil? ? I18n.t('no_picture_available') :
          image_tag(p.picture.thumb('200x200').url)
      end
    end
    
    unless page.paragraphs.empty?      
      panel "Abschnitte" do
        table_for page.paragraphs, i18n: Paragraph do
          column :heading          
          column :text
          column :picture do |pg|
            pg.picture.nil? ? I18n.t('no_picture_available') :
              image_tag(pg.picture.thumb('200x200').url)
          end
        end
      end
    end
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs I18n.t('activerecord.models.static_page.one'), multipart: true do
      f.input :heading
      f.input :text
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
        p.input :picture, as: :file, hint:
          p.object.picture.nil? ? p.template.content_tag(:span, I18n.t('no_picture_available')) :
            p.template.image_tag(p.object.picture.thumb('200x200').url)
        p.input :remove_picture, as: :boolean
      end
    end
    f.buttons
  end
end
