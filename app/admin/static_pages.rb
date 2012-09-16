ActiveAdmin.register StaticPage do
  config.filters = false
  config.sort_order = "heading_asc"

  show title: :title do |page|
    attributes_table do 
      row :heading
      row :text
      table_for page.paragraphs do
        column :order do |paragraph|
          paragraph.heading
        end
        column :text do |paragraph|
          paragraph.text
        end
      end
    end
  end


  form do |f|
    f.inputs "Seite" do
      f.input :heading
      f.input :text
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
