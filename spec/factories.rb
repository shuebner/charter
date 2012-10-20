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
    begin_date Date.new(2013, 4, 1)
    end_date Date.new(2013, 9, 30)
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
end