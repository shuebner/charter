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
StaticPage.create(heading: "Revier", title: "Revier", text: "Revierseite")
StaticPage.create(heading: "Impressum", title: "Impressum", text: "Impressumsseite")

# Erstelle die gängigen Saisonarten
Season.create(name: "Vorsaison", 
  begin_date: Date.new(2013, 4, 1), end_date: Date.new(2013, 5, 30))
Season.create(name: "Hauptsaison",
  begin_date: Date.new(2013, 6, 1), end_date: Date.new(2013, 8, 31))
Season.create(name: "Nachsaison",
  begin_date: Date.new(2013, 9, 1), end_date: Date.new(2013, 9, 30))

# Erstelle die gängigen Schiffspreisarten
BoatPriceType.create(name: "Tagescharter", duration: 1)
BoatPriceType.create(name: "Wochenendcharter", duration: 2)
BoatPriceType.create(name: "Viertagecharter", duration: 4)
BoatPriceType.create(name: "Wochencharter", duration: 7)
