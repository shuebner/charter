# encoding: utf-8
ActiveAdmin.register Trip do
  menu parent: I18n.t("trip_data")

  config.filters = false
  config.sort_order = 'name_asc'

  member_action :activate, method: :put do
    trip = Trip.find(params[:id])
    trip.activate!
    trip.save
    redirect_to admin_trips_path,
      notice: "Törn #{trip.name} wurde aktiviert"
  end

  member_action :deactivate, method: :put do
    trip = Trip.find(params[:id])
    trip.deactivate!
    trip.save
    redirect_to admin_trips_path,
      notice: "Törn #{trip.name} wurde deaktiviert"
  end

  index do
    column :name
    column :composite_trip
    column :no_of_bunks
    column(:price) { |t| number_to_currency(t.price) }
    column(Boat.model_name.human) { |t| t.boat.name }

    column :active do |t|
      status_tag (t.active? ? "ja" : "nein"), (t.active? ? :ok : :error)
    end
    column() do |t|
      if t.active?
        link_to "deaktivieren", deactivate_admin_trip_path(t), method: :put,
          confirm: "Törn #{t.name} wirklich deaktivieren?"
      else
        link_to "aktivieren", activate_admin_trip_path(t), method: :put,
          confirm: "Sie haben die Törndaten korrekturgelesen "\
            "und möchten den Törn #{t.name} wirklich aktivieren?"
      end
    end
    default_actions
  end

  show title: :name do |t|
    attributes_table do
      row :name
      row :composite_trip
      row :no_of_bunks
      row(:price) { number_to_currency(t.price) }
      row :description
      row :boat
      row :active do |b|
        status_tag (b.active? ? "ja" : "nein"), (b.active? ? :ok : :error)
      end      
    end

    panel t("activerecord.models.trip_image.other") do
      table_for t.images, i18n: TripImage do
        column :order
        column :attachment_title
        column(:attachment) { |i| image_tag(i.attachment.thumb('200x200').url) }
      end
    end
    
    panel "Termine" do
      table_for t.trip_dates, i18n: TripDate do
        column :start_at
        column :end_at
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :composite_trip
      f.input :no_of_bunks
      f.input :price
      f.input :description
      f.input :boat, collection: Boat.bunk_charter_only
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
