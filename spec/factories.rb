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
    year_of_construction "2011"
    available_for_boat_charter true
    available_for_bunk_charter false
  end
end