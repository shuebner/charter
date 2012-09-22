# encoding: utf-8

FactoryGirl.define do
  factory :static_page do
    slug "start"
    title "Seite"
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

  factory :boat_type do
    manufacturer "Testschiffhersteller"
    model "Testschiff"
    length_hull "12.34"
    displacement "7.4"
    sail_area_main_sail "51.3"
    tank_volume_diesel "100"
    headroom_saloon "1.90"
  end

  factory :boat do
    boat_type
    name "Palve Primus"
    slug "palve-primus"
    year_of_construction "2011"
    available_for_boat_charter true
    available_for_bunk_charter false
    deposit "500"
    fuel_charge "4.50"
  end
end