# encoding: utf-8
namespace :db do
  desc "create sample data for static pages"
  task populate: :environment do
    StaticPage.create!(slug: 'start', title: 'Willkommen', 
      heading: 'Start', text: 'Hier ist Palve-Charter Müritz')
    StaticPage.create!(slug: 'revier', title: 'Revier',
      heading: 'Revier', text: 'Mecklenburgische Seenplatte')
    StaticPage.create!(slug: 'toerns', title: 'Törns',
      heading: 'Törns', text: 'Törnvorschläge für die Müritz')
    StaticPage.create!(slug: 'impressum', title: 'Impressum',
      heading: 'Impressum', text: 'Klaus Wenz<br>Palve-Charter')

    start = StaticPage.find_by_slug('start')
    (1..3).each do |n|
      start.paragraphs.create!(
        heading: "Abschnitt #{n}", 
        text: "Hier ist ein Text für den #{n}. Abschnitt, der vielleicht "\
              "unter Umständen und mit viel Glück auch zur Abwechslung mal "\
              "länger ist als eine einzige Zeile",
        order: n)
    end
  end
end