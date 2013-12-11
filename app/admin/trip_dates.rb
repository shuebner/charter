# encoding: utf-8
ActiveAdmin.register TripDate do
  menu parent: I18n.t("trip_data")

  config.sort_order = 'start_at_asc'
  filter :trip_boat_slug, label: I18n.t("activerecord.models.boat.one"), as: :select,
    collection: Proc.new { Boat.bunk_charter_only.map { |b| [b.display_name, b.slug] } }
  filter :trip
  filter :start_at
  filter :end_at

  scope :all do |dates|
    dates.includes [{ trip: :boat }]
  end

  scope :in_current_period, default: true do |dates|
    dates.in_current_period.includes [{ trip: :boat }]
  end

  member_action :defer, method: :put do
    trip_date = TripDate.find(params[:id])
    trip_date.defer!
    if trip_date.save
      redirect_to admin_trip_dates_path,
        notice: "Törntermin #{trip_date.display_name_with_trip} wurde zurückgestellt."
    else
      redirect_to admin_trip_dates_path,
        alert: "Törntermin #{trip_date.display_name_with_trip} konnte nicht zurückgestellt werden. "\
                "Fehler: #{trip_date.errors[:deferred].join(', ')}"
    end
  end

  member_action :undefer, method: :put do
    trip_date = TripDate.find(params[:id])
    trip_date.undefer!
    if trip_date.save
      redirect_to admin_trip_dates_path,
        notice: "Törntermin #{trip_date.display_name_with_trip} wurde reaktiviert."
    else
      redirect_to admin_trip_dates_path,
        alert: "Törntermin #{trip_date.display_name_with_trip} konnte nicht reaktiviert werden. "\
                "Fehler: #{trip_date.errors[:start_at].join(', ')}"
    end
  end

  action_item only: :show, if: Proc.new { !trip_date.deferred? } do
    button_to "zurückstellen", defer_admin_trip_date_path, method: :put,
      confirm: "Törntermin #{trip_date.display_name_with_trip} wirklich zurückstellen?"
  end

  action_item only: :show, if: Proc.new { trip_date.deferred? } do
    button_to "reaktivieren", undefer_admin_trip_date_path, method: :put,
      confirm: "Törntermin #{trip_date.display_name_with_trip} wirklich reaktivieren?"
  end

  index do
    column :trip, sortable: 'trips.name'
    column I18n.t("activerecord.models.boat.one"), sortable: 'boats.name' do |td| 
      link_to td.trip.boat.name, admin_boat_path(td.trip.boat)
    end
    column :start_at
    column :end_at
    column(:deferred) do |td|
      status_tag (td.deferred? ? "ja" : "nein"), (td.deferred? ? :error : :ok)
    end
    column do |td|
      if td.deferred?
        link_to "reaktivieren", undefer_admin_trip_date_path(td), method: :put,
          confirm: "Törntermin #{td.display_name_with_trip} wirklich reaktivieren?"
      else
        link_to "zurückstellen", defer_admin_trip_date_path(td), method: :put,
          confirm: "Törntermin #{td.display_name_with_trip} wirklich zurückstellen?"
      end
    end
    default_actions
  end

  show title: :display_name_with_trip do |td|
    attributes_table do
      row :trip
      row(I18n.t("activerecord.models.boat.one")) { |td| td.trip.boat.display_name }
      row :start_at
      row :end_at
      row(:deferred) do |td|
        status_tag (td.deferred? ? "ja" : "nein"), (td.deferred? ? :error : :ok)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :trip
      f.input :start_at
      f.input :end_at
    end
    f.actions
  end
end
