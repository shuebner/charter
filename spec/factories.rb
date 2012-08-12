# encoding: utf-8

FactoryGirl.define do
  factory :static_page do
    name    "page"
    title   "Seite"
    heading "Überschrift"
    text    %#Text mit <h2>Überschrift</h2><h3>Unterüberschrift</h3><p>Einem
      Absatz</p>und einem <br> Zeilenwechsel und einem <a href="www.google.de">
      Link zu Google</a>#
  end

  factory :paragraph do
    sequence(:heading) { |n| "Abschnitt #{n}" }
    text     "Hier ist ein Text für den Abschnitt, der vielleicht Unter
      Umständen und mit viel Glück auch zur Abwechslung mal länger ist als
      eine einzige Zeile"
    sequence(:order) { |n| n }
    static_page
  end
end