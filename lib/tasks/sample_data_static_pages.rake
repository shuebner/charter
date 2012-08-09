# encoding: utf-8
namespace :db do
  desc "create sample data for static pages"
  task populate: :environment do
    StaticPage.create!(name: 'start', title: 'Willkommen', 
      heading: 'Start', text: 'Hier ist Palve-Charter Müritz')
    StaticPage.create!(name: 'area', title: 'Revier',
      heading: 'Revier', text: 'Mecklenburgische Seenplatte')
    StaticPage.create!(name: 'trips', title: 'Törns',
      heading: 'Törns', text: 'Törnvorschläge für die Müritz')
    StaticPage.create!(name: 'imprint', title: 'Impressum',
      heading: 'Impressum', text: 'Klaus Wenz<br>Palve-Charter')
  end
end