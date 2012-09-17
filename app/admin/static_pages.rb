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
      unless page.paragraphs.empty?
        table_for page.paragraphs do
          column :order do |paragraph|
            paragraph.order
          end
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

  form html: {enctype: "multipart/form-data"} do |f|
    f.inputs "Statische Seite", multipart: true do
      f.input :heading
      f.input :text
      f.input :picture, as: :file, hint: 
        f.object.picture.nil? ? f.template.content_tag(:span, I18n.t('no_picture_available')) : 
          f.template.image_tag(f.object.picture.thumb('200x200').url)
      f.input :remove_picture, as: :boolean
    end

    f.has_many :paragraphs do |p_f|
      p_f.inputs "Abschnitt" do
        if !p_f.object.nil?
          p_f.input :_destroy, as: :boolean, label: "Entfernen?"
        end

        p_f.input :order
        p_f.input :heading
        p_f.input :text
      end
    end
    f.buttons
  end
end
