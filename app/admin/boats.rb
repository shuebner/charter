# encoding: utf-8

ActiveAdmin.register Boat do
  config.filters = false
  config.sort_order = 'name_asc'
  
  index do
    column :name
    column :year_of_construction
    column :manufacturer
    column :model
    column(:length_hull) { |b| number_with_delimiter b.length_hull }
    column(:beam) { |b| number_with_delimiter b.beam }
    column(:draft) { |b| number_with_delimiter b.draft }
    column(:displacement) { |b| number_with_delimiter b.displacement }
    default_actions
  end

  show title: :name do |b|
    #attributes_table do
    panel t("boat_data") do
      attributes_table_for b do
        row :name
        row :manufacturer
        row :model
        row :year_of_construction
        row :year_of_refit
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
        row :engine_manufacturer
        row :engine_model
        row :engine_design
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

  form do |f|
    f.inputs t("boat_data") do
      f.input :name
      f.input :manufacturer
      f.input :model
      f.input :year_of_construction
      f.input :year_of_refit
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
      f.input :engine_manufacturer
      f.input :engine_model
      f.input :engine_design
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
    f.buttons
  end
end