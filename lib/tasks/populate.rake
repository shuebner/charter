namespace :db do
  desc "Erase and fill database"
  task populate: :environment do
    require 'populator'
    require 'faker'

    [Customer, TripDate, Trip, Boat].each(&:delete_all)

    Boat.populate 7 do |b|
      b.manufacturer = Faker::Company.name
      b.length_hull = l = rand(600..1600) / 100
      b.model = "#{b.manufacturer} #{(l * 3.3).ceil}"
      b.length_waterline = l * 0.9
      b.beam = l * 0.27
      b.draft = l * 0.17
      b.air_draft = l * 1.1
      b.displacement = l * 0.6
      b.sail_area_jib = l * 2
      b.sail_area_genoa = l * 3
      b.sail_area_main_sail = l * 2.7
      b.tank_volume_diesel = [50, 100, 200, 300, 400]
      b.tank_volume_fresh_water = [50, 100, 200, 300, 400]
      b.tank_volume_waste_water = [10, 20, 50, 100]
      b.permanent_bunks = [2, 3, 4, 5, 6]
      b.convertible_bunks = [0, 1, 2]
      b.max_no_of_people = b.permanent_bunks + b.convertible_bunks
      b.recommended_no_of_people = b.permanent_bunks
      b.headroom_saloon = rand(180..200) / 100
      b.name = Faker::Name.first_name
      b.slug = b.name.parameterize
      b.year_of_construction = rand(1970..2005)
      b.year_of_refit = 2006..2012
      b.engine_manufacturer = Faker::Company.name
      b.engine_model = Faker::Name.name
      b.engine_design = ["Saildrive", "Propeller"]
      b.engine_output = l * 5
      b.battery_capacity = l * 25
      b.available_for_boat_charter = [true, false]
      b.available_for_bunk_charter = [true, false]
      if b.available_for_boat_charter
        b.deposit = [500, 1000, 2000]
        b.cleaning_charge = [50, 75, 100]
        b.fuel_charge = 5..10
        b.gas_charge = [rand(4..8), 0]
      end
      b.created_at = 2.years.ago..Time.now

      if b.available_for_bunk_charter
        Trip.populate 1..4 do |t|
          t.boat_id = b.id
          t.name = Faker::Name.name
          t.slug = t.name.parameterize
          t.description = Populator.sentences(5..10)
          t.no_of_bunks = b.permanent_bunks - 1
          t.price = rand(22..80) * 10
          TripDate.populate 2..4 do |td|
            td.trip_id = t.id
            td.begin = 6.months.from_now..10.months.from_now
            td.end = td.begin + rand(3..7).days
          end
        end
      end
    end

    Customer.populate 200 do |c|
      c.first_name = Faker::Name.first_name
      c.last_name = Faker::Name.last_name
      full_name = "#{c.first_name} #{c.last_name}"
      c.slug = full_name.parameterize
      c.gender = %w[m w].sample
      c.street_name = Faker::Address.street_name
      c.street_number = "#{rand(1..300)}#{["", "", "", "a", "b"].sample}"
      c.zip_code = "#{rand(10000..99999)}"
      c.city = Faker::Address.city
      c.country = ["Deutschland", Faker::Address.country].sample
      c.phone_landline = "0#{rand(10..999)}-#{rand(100000..9999999)}"
      c.phone_mobile = "0#{rand(10..999)}-#{rand(100000..9999999)}"
      c.email = Faker::Internet.email(full_name)
    end
  end
end