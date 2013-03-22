# encoding: utf-8

ActiveAdmin.register CompositeTrip do
  menu parent: I18n.t("trip_data")

  config.filters = false
  config.sort_order = 'name_asc'

  member_action :activate, method: :put do
    ctrip = CompositeTrip.find(params[:id])
    ctrip.activate!
    ctrip.save
    redirect_to admin_composite_trips_path,
      notice: "Etappentörn #{ctrip.name} wurde aktiviert"
  end

  member_action :deactivate, method: :put do
    ctrip = CompositeTrip.find(params[:id])
    ctrip.deactivate!
    ctrip.save
    redirect_to admin_composite_trips_path,
      notice: "Etappentörn #{ctrip.name} wurde deaktiviert"
  end

  index do
    column :name
    column :boat
    column(:active) do |ct|
      status_tag (ct.active? ? "ja" : "nein"), (ct.active? ? :ok : :error)
    end
    column() do |ct|
      if ct.active?
        link_to "deaktivieren", deactivate_admin_composite_trip_path(ct), method: :put,
          confirm: "Etappentörn #{ct.name} wirklich deaktivieren?"
      else
        link_to "aktivieren", activate_admin_composite_trip_path(t), method: :put,
          confirm: "Sie haben die Törndaten korrekturgelesen "\
            "und möchten den Etappentörn #{ct.name} wirklich aktivieren?"
      end
    end
    default_actions
  end

  show title: :name do |ct|
    attributes_table do
      row :name
      row :boat
      row :description
      row :active do
        status_tag (ct.active? ? "ja" : "nein"), (ct.active? ? :ok : :error)
      end
    end

    panel t("activerecord.models.composite_trip_image.other") do
      table_for ct.images, i18n: CompositeTripImage do
        column :order
        column :title
        column(:attachment) { |i| image_tag(i.thumb('200x200').url) }
      end
    end

    panel t("activerecord.attributes.composite_trip.trips") do
      table_for ct.trips, i18n: Trip do
        column(:name) { |t| link_to t.name, admin_trip_path(t) }
        column(:start_at) { |t| l(t.trip_dates.first.start_at) }
        column(:end_at) { |t| l(t.trip_dates.first.end_at) }
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :boat, collection: Boat.bunk_charter_only
      f.input :description
    end

    unless f.object.new_record?
      f.has_many :images do |i|
        i.inputs do
          if !i.object.nil?
            i.input :_destroy, as: :boolean, label: "Bild löschen"
          end
          i.input :order
          i.input :attachment_title
          i.input :attachment, as: :file,
            hint: i.object.attachment.nil? ?
              i.template.content_tag(:span, t("no_picture_available")) :
              i.template.image_tag(i.object.thumb('200x200').url)
          i.input :retained_attachment, as: :hidden
        end
      end
    end
    f.actions
  end
end
