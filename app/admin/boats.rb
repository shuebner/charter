# encoding: utf-8

ActiveAdmin.register Boat do
  config.filters = false
  config.sort_order = 'name_asc'
  
  index do
    column :name
    column :year_of_construction
    column :manufacturer
    column :model
    column(:length_hull) { |boat| number_with_delimiter boat.length_hull }
    column(:beam) { |boat| number_with_delimiter boat.beam }
    column(:draft) { |boat| number_with_delimiter boat.draft }
    column(:displacement) { |boat| number_with_delimiter boat.displacement }
    default_actions
  end

  show title: :name do |boat|
    attributes_table do
      row :name
      row :manufacturer
      row :model
      row :year_of_construction
      row :year_of_refit
      row(:length_hull) { |boat| number_with_delimiter boat.length_hull }
      row(:length_waterline) { |boat| number_with_delimiter boat.length_waterline }
      row(:beam) { |boat| number_with_delimiter boat.beam }
      row(:draft) { |boat| number_with_delimiter boat.draft }
      row(:air_draft) { |boat| number_with_delimiter boat.air_draft }
      row(:displacement) { |boat| number_with_delimiter boat.displacement }
      row(:sail_area_jib) { |boat| number_with_delimiter boat.sail_area_jib }
      row(:sail_area_genoa) { |boat| number_with_delimiter boat.sail_area_genoa }
      row(:sail_area_main_sail) { |boat| number_with_delimiter boat.sail_area_main_sail }
      row(:total_sail_area_with_jib) { |boat| number_with_delimiter boat.total_sail_area_with_jib }
      row(:total_sail_area_with_genoa) { |boat| number_with_delimiter boat.total_sail_area_with_genoa }
      row :engine_manufacturer
      row :engine_model
      row :engine_design
      row(:engine_output) { |boat| number_with_delimiter boat.engine_output }
      row(:battery_capacity) { |boat| number_with_delimiter boat.battery_capacity }
      row(:tank_volume_diesel) { |boat| number_with_delimiter boat.tank_volume_diesel }
      row(:tank_volume_fresh_water) { |boat| number_with_delimiter boat.tank_volume_fresh_water }
      row(:tank_volume_waste_water) { |boat| number_with_delimiter boat.tank_volume_waste_water }
      row :permanent_bunks
      row :convertible_bunks
      row :max_no_of_people
      row :recommended_no_of_people
      row(:headroom_saloon) { |boat| number_with_delimiter boat.headroom_saloon }
      row :available_for_boat_charter do |boat|
        status_tag (boat.available_for_boat_charter ? "ja" : "nein"),
          (boat.available_for_boat_charter ? :ok : :error)
      end
      row :available_for_bunk_charter do |boat|
        status_tag (boat.available_for_bunk_charter ? "ja" : "nein"),
          (boat.available_for_bunk_charter ? :ok : :error)
      end
      row(:deposit) { |boat| number_to_currency boat.deposit }
      row(:cleaning_charge) { |boat| number_to_currency boat.cleaning_charge }
      row(:fuel_charge) { |boat| number_to_currency boat.fuel_charge }
      row(:gas_charge) { |boat| number_to_currency boat.gas_charge }
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