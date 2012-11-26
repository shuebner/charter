# encoding: utf-8

FactoryGirl.define do
  factory :static_page do
    sequence(:title) { |n| "Seite #{n}" }
    heading "Überschrift"
    text    %#Text mit <h2>Überschrift</h2><h3>Unterüberschrift</h3><p>Einem
      Absatz</p>und einem <br> Zeilenwechsel und einem <a href="www.google.de">
      Link zu Google</a>#
  end

  factory :paragraph do
    sequence(:heading) { |n| "Abschnitt #{n}" }
    sequence(:text) do |n| 
      "Hier ist ein Text für den #{n}. Abschnitt, der vielleicht unter
      Umständen und mit viel Glück auch zur Abwechslung mal länger ist als
      eine einzige Zeile"
    end
    sequence(:order) { |n| n }
    static_page
  end

  factory :boat do
    manufacturer "Testschiffhersteller"
    model "Testschiff"
    sequence(:name) { |n| "Palve #{n}" }
    year_of_construction 2011
    permanent_bunks 4
    convertible_bunks 2
    deposit 1000
    cleaning_charge 50
    fuel_charge 7
    gas_charge 5
    available_for_boat_charter true
    available_for_bunk_charter true

    factory :boat_charter_only_boat do
      available_for_boat_charter true
      available_for_bunk_charter false
    end

    factory :bunk_charter_only_boat do
      deposit nil
      cleaning_charge nil
      fuel_charge nil
      gas_charge nil
      available_for_boat_charter false
      available_for_bunk_charter true
    end

    factory :unavailable_boat do
      deposit nil
      cleaning_charge nil
      fuel_charge nil
      gas_charge nil
      available_for_boat_charter false
      available_for_bunk_charter false
    end      
  end

  factory :trip do
    sequence(:name) { |n| "Törn #{n}"}
    description "Ein ganz toller Törn. Hurra, ich freu mich drauf"
    no_of_bunks 3
    price 560
    boat
  end

  factory :trip_date do
    sequence(:begin) { |n| (n*7).day.from_now }
    sequence(:end) { |n| (n*7+4).day.from_now }
    trip
  end

  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender ["m", "w"].sample
  end

  factory :trip_booking do
    no_of_bunks 2
    trip_date
    customer
  end

  factory :season do
    sequence(:name) { |n| "Saison #{n}" }
    sequence(:begin_date) { |n| Date.new(2013, 4, 1) + n.years }
    sequence(:end_date) { |n| Date.new(2013, 9, 30) + n.years }
    
    factory :early_season do
      name "Vorsaison"
      begin_date Date.new(2013, 4, 1)
      end_date Date.new(2013, 5, 31)
    end

    factory :main_season do
      name "Hauptsaison"
      begin_date Date.new(2013, 6, 1)
      end_date Date.new(2013, 8, 31)
    end

    factory :late_season do
      name "Nachsaison"
      begin_date Date.new(2013, 9, 1)
      end_date Date.new(2013, 9, 30)
    end
  end

  factory :boat_price_type do
    sequence(:name) { |n| "#{n}-Tagespreis" }
    sequence(:duration) { |n| n }
  end

  factory :boat_price do
    sequence(:value) { |n| n*100 }
    boat_price_type
    season
    boat
  end

  factory :attachment do
    attachable { FactoryGirl.create(:boat) }
    attachment File.new("/home/sven/Bilder/random file.rnd")
    attachment_title "Eine zufällige Datei"
    sequence(:order) { |n| n }
    factory :image, class: Image do
      attachment File.new("/home/sven/Bilder/HYS3.jpg")
      sequence(:attachment_title) { |n| "Ein schönes Bild #{n}" }
      factory :boat_image, class: BoatImage do
      end
      factory :trip_image, class: TripImage do
        attachable { FactoryGirl.create(:trip) }
      end
      factory :captain_image, class: CaptainImage do
        attachable { FactoryGirl.create(:captain) }
      end
    end
    factory :document, class: Document do
      attachment File.new("/home/sven/Dokumente/Anforderungen.pdf")
      sequence(:attachment_title) { |n| "Ein Dokument #{n}" }
    end
  end

  factory :captain do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_mobile "01234-12345678"
  end

  factory :inquiry do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email("#{first_name} #{last_name}") }
    factory :full_inquiry do
      text { Faker::Lorem.sentence(4) }
    end
    factory :trip_inquiry, class: TripInquiry do
      trip_date
      bunks 1
      factory :full_trip_inquiry do
        text { Faker::Lorem.sentence(4) }
      end
    end
  end
end