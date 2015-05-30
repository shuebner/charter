# encoding: utf-8
require 'spec_helper'

describe "Navigation" do
  let!(:root_page) do
    StaticPage.create!(title: 'Start', 
      heading: 'Willkommen', text: 'Hier ist Palve-Charter Müritz')
  end
  subject { page }

  describe "Link to the only boat" do
    # Schiffseigner
    let!(:myself) { create(:boat_owner, is_self: true) }
    
    # Hafen des Seitenbetreibers mit 1 sichtbarem Schiff
    let!(:own_port_with_visible_boat) { create(:port, name: "Zamonien") }
    let!(:own_visible_boat1) { create(:boat, port: own_port_with_visible_boat, 
      owner: myself, name: "Adam 24") }

    before { visit root_path }

    it "should contain a link to one of the boats (there should be only one" do
      within 'nav' do
        page.should have_link("Die Palve", href: boat_path(own_visible_boat1))
      end
    end
  end

  describe "Links to trips" do
    let!(:active_trip) { create(:trip, name: "Zamonien", active: true) }
    let!(:previous_active_trip) { create(:trip, name: "Hel", active: true) }
    let!(:inactive_trip) { create(:trip, active: false) }
    let!(:composite_trip) { create(:composite_trip, name: "Finsterwald") }
    let!(:trip_for_composite_trip) { create(:trip_for_composite_trip, 
      composite_trip: composite_trip) }
    let!(:previous_composite_trip) { create(:composite_trip, name: "Buntbärenwald") }
    let!(:inactive_composite_trip) { create(:composite_trip, active: false) }
    before { visit root_path }

    it "should include a link to every active trip at the bottom ascending by name" do      
      within "nav ul li#trips ul" do
        page.should have_selector('li:nth-child(3)', text: previous_active_trip.name)
        page.should have_selector('li:nth-child(4)', text: active_trip.name)
      end
    end
    it "should not include a link to any inactive trip" do
      within "nav ul li#trips ul" do
        page.should_not have_selector('li', text: inactive_trip.name)
      end
    end
    it "should not include a link to any trip which belongs to a composite trip" do
      within "nav ul li#trips ul" do
        page.should_not have_selector('li', text: trip_for_composite_trip.name)
      end
    end
    it "should include a link to composite trips at the top" do
      within "nav ul li#trips ul" do
        page.should have_selector('li:nth-child(1)', text: previous_composite_trip.name)
        page.should have_selector('li:nth-child(2)', text: composite_trip.name)
      end
    end
    it "should not include a link to inactive composite trips" do
      within "nav ul li#trips ul" do
        page.should_not have_selector('li', text: inactive_composite_trip.name)
      end
    end
  end
end