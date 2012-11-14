# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Erstelle einen Admin-User
AdminUser.create(email: "admin@example.com", 
  password: "password", password_confirmation: "password")

# Erstelle die nötigen Statischen Seiten
StaticPage.create(heading: "Willkommen", title: "Start", text: "Startseite")
StaticPage.create(heading: "Reisebedigungen", title: "Reisebedingungen", text: "Reisebedingungsseite")
StaticPage.create(heading: "Impressum", title: "Impressum", text: "Impressumsseite")

# Erstelle die gängigen Saisonarten
Season.create(name: "April", 
  begin_date: Date.new(2013, 4, 1), end_date: Date.new(2013, 4, 30))
Season.create(name: "Mai/Juni",
  begin_date: Date.new(2013, 5, 1), end_date: Date.new(2013, 6, 30))
Season.create(name: "Juli/August",
  begin_date: Date.new(2013, 7, 1), end_date: Date.new(2013, 8, 31))
Season.create(name: "September",
  begin_date: Date.new(2013, 9, 1), end_date: Date.new(2013, 9, 30))

# Erstelle die gängigen Schiffspreisarten
BoatPriceType.create(name: "Wochencharter", duration: 7)
