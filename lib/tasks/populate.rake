# encoding: utf-8

namespace :db do
  desc "Erase and fill database"
  task populate: :environment do
    require 'populator'
    require 'faker'

    [Customer, Port, BoatOwner, TripBooking, TripDate, Trip, 
      CompositeTrip, Boat, BoatPrice, Captain, Attachment,
      GeneralInquiry, BoatInquiry, TripInquiry,
      Partner].each(&:delete_all)
    booking_number = "000"
    customer_number = 31200
    

    Customer.populate 100 do |c|
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
      c.number = customer_number
      c.has_sks_or_higher = [true, false, nil]
      customer_number += 1
    end

    BoatOwner.populate 3 do |bo|
      bo.name = Faker::Name.name
      bo.slug = bo.name.parameterize
      bo.is_self = false
    end

    BoatOwner.populate 1 do |bo|
      bo.name = "Palve-Charter"
      bo.slug = "palve-charter"
      bo.is_self = true
    end

    Port.populate 5 do |p|
      p.name = Faker::Address.city
      p.slug = p.name.parameterize
    end

    Boat.populate 7 do |b|
      b.available_for_boat_charter = [true, false]
      b.available_for_bunk_charter = [true, false]
      set_boat_attributes_except_availability(b)

      if b.available_for_bunk_charter
        Trip.populate 1..4 do |t|
          t.boat_id = b.id
          t.name = Faker::Name.name
          t.slug = t.name.parameterize
          t.description = Populator.sentences(5..10)
          t.no_of_bunks = b.permanent_bunks - 1
          t.price = rand(22..80) * 10
          t.active = true
        end
      end
    end

    # create composite trip on separate boat
    1.times do
      b = Boat.new
      b.available_for_boat_charter = false
      b.available_for_bunk_charter = true
      set_boat_attributes_except_availability(b)
      b.save!

      ct = CompositeTrip.new
      ct.name = "Etappentörn #{Date.today.year}"
      ct.slug = ct.name.parameterize
      ct.description = Populator.sentences(5..10)
      ct.active = true
      ct.boat_id = b.id
      ct.save!
      
      3.times do |n|
        i = ct.images.build
        i.order = n + 1
        i.attachment = [File.new("/home/sven/Bilder/HYS3-quer.jpg"), File.new("/home/sven/Bilder/HYS3.jpg")].sample
        i.attachment_title = Populator.words(2..5)
        i.save!
      end

      4.times do |n|
        t = ct.trips.build
        t.name = "Etappe #{n + 1}"
        t.slug = t.name.parameterize
        t.description = Populator.sentences(5..10)
        t.no_of_bunks = 2
        t.price = 500
        t.active = true
        t.boat_id = ct.boat_id
        t.save!

        td = t.trip_dates.build
        td.start_at = DateTime.new(2013, 6, 3, 10, 0, 0) + (n*14).days
        td.end_at = td.start_at + 13.days
        td.save!

        rand(2..5).times do |n|
          i = t.images.build          
          i.order = n + 1
          i.attachment = [File.new("/home/sven/Bilder/HYS3-quer.jpg"), File.new("/home/sven/Bilder/HYS3.jpg")].sample
          i.attachment_title = Populator.words(2..5)
          i.save!          
        end
      end
    end    

    Boat.all.each do |b|
      rand(3..10).times do |n|
        i = b.images.build
        i.order = n + 1
        i.attachment = [File.new("/home/sven/Bilder/HYS3-quer.jpg"), File.new("/home/sven/Bilder/HYS3.jpg")].sample
        i.attachment_title = Populator.words(2..5)
        i.save!
      end      
    end

    Season.all.each do |s|
      BoatPriceType.all.each do |bpt|
        Boat.boat_charter_only.each do |b|
          BoatPrice.populate 1 do |p|
            p.boat_id = b.id
            p.season_id = s.id
            p.boat_price_type_id = bpt.id
            p.value = 500..2000
          end
        end
      end
    end

    Captain.populate 3 do |c|
      c.first_name = Faker::Name.first_name
      c.last_name = Faker::Name.last_name
      full_name = "#{c.first_name} #{c.last_name}"
      c.slug = full_name.parameterize
      c.sailing_certificates = Populator.words(2..5).split(' ').join('; ')
      c.additional_certificates = Populator.words(2..5).split(' ').join('; ')
      c.description = Populator.sentences(5..10)
      c.email = Faker::Internet.email(full_name)
      c.phone_mobile = "0#{rand(10..999)}-#{rand(100000..9999999)}"
    end

    Captain.all.each do |c|
      rand(3..10).times do |n|
        i = c.build_image
        i.order = n + 1
        i.attachment = [File.new("/home/sven/Bilder/HYS3-quer.jpg"), File.new("/home/sven/Bilder/HYS3.jpg")].sample
        i.attachment_title = Populator.words(2..5)
        i.save!
      end        
    end

    GeneralInquiry.populate 6 do |i|
      i.type = "GeneralInquiry"
      i.first_name = Faker::Name.first_name
      i.last_name = Faker::Name.last_name
      i.email = Faker::Internet.email("#{i.first_name} #{i.last_name}")
      i.text = Populator.sentences(1..10)
    end

    6.times do |n|
      i = BoatInquiry.new
      i.first_name = Faker::Name.first_name
      i.last_name = Faker::Name.last_name
      i.email = Faker::Internet.email("#{i.first_name} #{i.last_name}")
      i.text = Populator.sentences(1..4)
      i.boat_id = Boat.all.map(&:id).sample
      i.begin_date = Date.new(2013, 4, 1) + (n*7).days
      i.end_date = i.begin_date + rand(3..14).days
      i.adults = rand(1..3)
      i.children = 0
      i.save!
    end

    Trip.where("composite_trip_id IS NULL").each do |t|
      rand(2..4).times do |n|
        i = t.images.build
        i.order = n + 1
        i.attachment = [File.new("/home/sven/Bilder/HYS3-quer.jpg"), File.new("/home/sven/Bilder/HYS3.jpg")].sample
        i.attachment_title = Populator.words(2..5)
        i.save!
      end
      rand(2..4).times do |n|
        td = TripDate.new
        td.trip_id = t.id
        td.start_at = rand(DateTime.new(2013, 7, 1)..DateTime.new(2013, 9, 30))
        td.end_at = td.start_at + rand(3..7).days
        if td.save
          rand(1..3).times do |m|
            tb = TripBooking.new            
            tb.trip_date_id = td.id
            tb.number = "T-#{td.start_at.year}-#{booking_number.succ!}"
            tb.slug = tb.number.downcase
            tb.customer_number = Customer.all.map(&:number).sample
            tb.no_of_bunks = 1
            tb.save
          end
        end
      end
    end

    10.times do
      i = TripInquiry.new
      i.first_name = Faker::Name.first_name
      i.last_name = Faker::Name.last_name
      i.email = Faker::Internet.email("#{i.first_name} #{i.last_name}")
      i.text = Populator.sentences(1..4)
      i.trip_date_id = TripDate.all.map(&:id).sample
      i.bunks = 1
      i.save
    end

    (1..8).each do |i|
      p = Partner.new
      p.name = Faker::Name.name
      p.url = Faker::Internet.url
      p.order = i
      p.save!
    end

    Partner.all.each do |p|
      p.build_image
      p.image.attachment = [File.new("/home/sven/Bilder/HYS3-quer.jpg"), File.new("/home/sven/Bilder/HYS3.jpg")].sample
      p.image.attachment_title = Populator.words(2..5)
      p.image.save!
    end
  end

  def set_boat_attributes_except_availability(b)
    b.boat_owner_id = BoatOwner.all.map(&:id).sample
    b.port_id = Port.all.map(&:id).sample
    b.manufacturer = Faker::Company.name
    b.length_hull = l = rand(600..1600).to_f / 100
    b.model = "#{b.manufacturer} #{(l * 3.3).ceil}"
    b.length_waterline = l * 0.9
    b.beam = l * 0.27
    b.draft = l * 0.17
    b.air_draft = l * 1.1
    b.displacement = l * 0.6
    b.sail_area_jib = l * 2
    b.sail_area_genoa = l * 3
    b.sail_area_main_sail = l * 2.7
    b.tank_volume_diesel = [50, 100, 200, 300, 400].sample
    b.tank_volume_fresh_water = [50, 100, 200, 300, 400].sample
    b.tank_volume_waste_water = [10, 20, 50, 100].sample
    b.permanent_bunks = [2, 3, 4, 5, 6].sample
    b.convertible_bunks = [0, 1, 2].sample
    b.max_no_of_people = b.permanent_bunks + b.convertible_bunks
    b.recommended_no_of_people = b.permanent_bunks
    b.headroom_saloon = rand(180..200).to_f / 100
    b.name = Faker::Name.first_name
    b.slug = b.name.parameterize
    b.year_of_construction = rand(1970..2005)
    b.year_of_refit = rand(2006..2012)
    b.engine_model = Faker::Name.name
    b.engine_output = (l * 5).to_i
    b.battery_capacity = (l * 25).to_i
    if b.available_for_boat_charter
      b.deposit = [500, 1000, 2000].sample
      b.cleaning_charge = [50, 75, 100].sample
      b.fuel_charge = rand(5..10)
      b.gas_charge = [rand(4..8), 0].sample
    end
    b.created_at = 2.years.ago..Time.now
    b.active = true
    b.color = "##{rand(2**24).to_s(16).rjust(6, '0')}"     
  end  
end