# encoding: utf-8
namespace :db do
  desc "create sample data for static pages"
  task populate: :environment do
    StaticPage.create!(name: 'start', title: 'Willkommen', 
      heading: 'Start', text: 'Hier ist Palve-Charter Müritz')
    StaticPage.create!(name: 'revier', title: 'Revier',
      heading: 'Revier', text: 'Mecklenburgische Seenplatte')
    StaticPage.create!(name: 'toerns', title: 'Törns',
      heading: 'Törns', text: 'Törnvorschläge für die Müritz')
    StaticPage.create!(name: 'impressum', title: 'Impressum',
      heading: 'Impressum', text: 'Klaus Wenz<br>Palve-Charter')

    start = StaticPage.find_by_name('start')
    3.times do |n|
      start.paragraphs.create!(
        heading: "Abschnitt #{n}", 
        text: "Hier ist ein Text für den #{n}. Abschnitt, der vielleicht unter
          Umständen und mit viel Glück auch zur Abwechslung mal länger ist als
          eine einzige Zeile",
        order: n)
    end
  end
end