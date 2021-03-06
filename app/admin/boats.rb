# encoding: utf-8

ActiveAdmin.register Boat do
  menu parent: I18n.t("boat_data")

  config.filters = false
  config.sort_order = 'name_asc'

  member_action :activate, method: :put do
    boat = Boat.find(params[:id])
    boat.activate!
    boat.save
    redirect_to admin_boats_path,
      notice: "Schiff #{boat.name} wurde aktiviert"
  end

  member_action :deactivate, method: :put do
    boat = Boat.find(params[:id])
    boat.deactivate!
    boat.save
    redirect_to admin_boats_path,
      notice: "Schiff #{boat.name} wurde deaktiviert"
  end
  
  index do
    column :owner
    column :port
    column :name
    column :model
    column :available_for_boat_charter do |b|
      status_tag (b.available_for_boat_charter ? "ja" : "nein"),
        (b.available_for_boat_charter ? :ok : :error)
    end
    column :available_for_bunk_charter do |b|
      status_tag (b.available_for_bunk_charter ? "ja" : "nein"),
        (b.available_for_bunk_charter ? :ok : :error)
    end
    column :active do |b|
      status_tag (b.active? ? "ja" : "nein"), (b.active? ? :ok : :error)
    end
    column() do |b|
      if b.active?
        link_to "deaktivieren", deactivate_admin_boat_path(b), method: :put,
          confirm: "Schiff #{b.name} wirklich deaktivieren?"
      else
        link_to "aktivieren", activate_admin_boat_path(b), method: :put,
          confirm: "Sie haben die Schiffsdaten korrekturgelesen "\
            "und möchten das Schiff #{b.name} wirklich aktivieren?"
      end
    end
    default_actions
  end

  show title: :name do |b|
    #attributes_table do
    panel t("boat_data") do
      attributes_table_for b do
        row :owner
        row :port
        row :name
        row :manufacturer
        row :model
        row :year_of_construction
        row :year_of_refit
        row :active do |b|
          status_tag (b.active? ? "ja" : "nein"), (b.active? ? :ok : :error)
        end
        row :color do |b|
          div(style: "width:6em; height:2em; background-color:#{b.color}")
          span "CSS-String: #{b.color}"
        end
      end
    end

    panel t("activerecord.models.boat_image.other") do
      table_for b.images, i18n: BoatImage do
        column :order
        column :attachment_title
        column(:attachment) { |i| image_tag(i.attachment.thumb('200x200').url) }
      end
    end

    panel t("activerecord.models.document.other") do
      table_for b.documents, i18n: Document do
        column :order
        column :attachment_title
        column :attachment_name
      end
    end    

    panel t("technical_data") do
      attributes_table_for b do
        row(:length_hull) { number_with_delimiter b.length_hull }
        row(:length_waterline) { number_with_delimiter b.length_waterline }
        row(:beam) { number_with_delimiter b.beam }
        row(:draft) { number_with_delimiter b.draft }
        row(:air_draft) { number_with_delimiter b.air_draft }
        row(:displacement) { number_with_delimiter b.displacement }
        row(:sail_area_jib) { number_with_delimiter b.sail_area_jib }
        row(:sail_area_genoa) { number_with_delimiter b.sail_area_genoa }
        row(:sail_area_main_sail) { number_with_delimiter b.sail_area_main_sail }
        row(:total_sail_area_with_jib) { number_with_delimiter b.total_sail_area_with_jib }
        row(:total_sail_area_with_genoa) { number_with_delimiter b.total_sail_area_with_genoa }
        row :engine_model
        row(:engine_output) { number_with_delimiter b.engine_output }
        row(:battery_capacity) { number_with_delimiter b.battery_capacity }
        row(:tank_volume_diesel) { number_with_delimiter b.tank_volume_diesel }
        row(:tank_volume_fresh_water) { number_with_delimiter b.tank_volume_fresh_water }
        row(:tank_volume_waste_water) { number_with_delimiter b.tank_volume_waste_water }
      end
    end

    panel t("living_data") do
      attributes_table_for b do
        row :permanent_bunks
        row :convertible_bunks
        row :max_no_of_people
        row :recommended_no_of_people
        row(:headroom_saloon) { number_with_delimiter b.headroom_saloon }
      end
    end

    panel t("charter_data") do
      attributes_table_for b do
        row :available_for_boat_charter do |b|
          status_tag (b.available_for_boat_charter ? "ja" : "nein"),
            (b.available_for_boat_charter ? :ok : :error)
        end
        row :available_for_bunk_charter do |b|
          status_tag (b.available_for_bunk_charter ? "ja" : "nein"),
            (b.available_for_bunk_charter ? :ok : :error)
        end
        row(:deposit) { |b| number_to_currency b.deposit }
        row(:cleaning_charge) { |b| number_to_currency b.cleaning_charge }
        row(:fuel_charge) { |b| number_to_currency b.fuel_charge }
        row(:gas_charge) { |b| number_to_currency b.gas_charge }
      end
    end
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs t("boat_data") do
      f.input :owner
      f.input :port
      f.input :name
      f.input :manufacturer
      f.input :model
      f.input :year_of_construction
      f.input :year_of_refit
      f.input :color
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

    f.has_many :documents do |d|
      d.inputs do
        if !d.object.nil?
          d.input :_destroy, as: :boolean, label: "Dokument löschen"
        end
        d.input :order
        d.input :attachment_title
        d.input :attachment, as: :file,
          hint: d.object.attachment.nil? ?
            d.template.content_tag(:span, I18n.t('no_document_available')) :
            d.object.attachment_name
        d.input :retained_attachment, as: :hidden
      end
    end

    f.inputs t("technical_data") do
      f.input :length_hull
      f.input :length_waterline
      f.input :beam
      f.input :draft
      f.input :air_draft
      f.input :displacement
      f.input :sail_area_jib
      f.input :sail_area_genoa
      f.input :sail_area_main_sail
      f.input :engine_model
      f.input :engine_output
      f.input :battery_capacity
      f.input :tank_volume_diesel
      f.input :tank_volume_fresh_water
      f.input :tank_volume_waste_water
    end

    f.inputs t("living_data") do
      f.input :permanent_bunks
      f.input :convertible_bunks
      f.input :max_no_of_people
      f.input :recommended_no_of_people
      f.input :headroom_saloon
    end

    f.inputs t("charter_data") do
      f.input :available_for_boat_charter
      f.input :available_for_bunk_charter
      f.input :deposit
      f.input :cleaning_charge
      f.input :fuel_charge
      f.input :gas_charge
    end
    f.actions
  end
end