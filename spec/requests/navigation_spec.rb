# encoding: utf-8
require 'spec_helper'

describe "Navigation" do
  let!(:root_page) do
    StaticPage.create!(title: 'Start', 
      heading: 'Willkommen', text: 'Hier ist Palve-Charter Müritz')
  end
  subject { page }

  describe "Links to boats" do
    # Schiffseigner
    let!(:myself) { create(:boat_owner, is_self: true) }
    let!(:someone_else) { create(:boat_owner, is_self: false) }

    # Hafen des Seitenbetreibers mit 2 sichtbaren Schiffen
    let!(:own_port_with_visible_boat) { create(:port, name: "Zamonien") }
    let!(:own_visible_boat2) { create(:boat, port: own_port_with_visible_boat, 
      owner: myself, model: "Zora 32") }
    let!(:own_visible_boat1) { create(:boat, port: own_port_with_visible_boat, 
      owner: myself, name: "Adam 24") }
    let!(:own_invisible_boat1) { create(:unavailable_boat, port: own_port_with_visible_boat,
      owner: myself) }
    let!(:own_invisible_boat2) { create(:boat, active: false, port: own_port_with_visible_boat) }

    # Häfen von anderen Vercharterern
    let!(:other_port_with_visible_boat2) { create(:port, name: "Xanten") }
    let!(:other_visible_boat2_1) { create(:boat, 
      owner: someone_else, port: other_port_with_visible_boat2) }

    let!(:other_port_with_visible_boat1) { create(:port, name: "Azeroth") }
    let!(:other_visible_boat1_1) { create(:boat, 
      owner: someone_else, port: other_port_with_visible_boat1) }

    # Hafen ohne verfügbares Boot
    let!(:port_without_visible_boat) { create(:port) }
    let!(:invisible_boat) { create(:unavailable_boat, port: port_without_visible_boat) }
    
    # fremdes Schiff in eigenem Hafen
    let!(:extern_boat_in_own_port) { create(:boat,
      owner: someone_else, port: own_port_with_visible_boat, model: "ZZZ") }
    
    before { visit root_path }
    
    it "should list every port with a visible boat, first own then external ports in alphabetical order" do
      within 'nav ul li#boats ul' do
        page.should have_selector('li:nth-child(1)', text: "Standort #{own_port_with_visible_boat.name}")
        page.should have_selector('li:nth-child(2)', text: "Standort #{other_port_with_visible_boat1.name}")
        page.should have_selector('li:nth-child(3)', text: "Standort #{other_port_with_visible_boat2.name}")
      end
    end

    it "should not list ports with invisible boats" do
      within 'nav ul li#boats ul' do
        page.should_not have_selector('li', text: port_without_visible_boat.name)
      end
    end

    it "should not list ports with own and external boats twice" do
      within 'nav ul li#boats ul' do
        page.all('li', text: own_port_with_visible_boat.name).count.should == 1
      end
    end

    describe "within a port" do
      it "should list visible boats in alphabetical order" do
        within 'nav ul li#boats ul li:nth-child(1) ul' do
          page.should have_selector('li:nth-child(1)', text: own_visible_boat1.display_name)
          page.should have_selector('li:nth-child(2)', text: own_visible_boat2.display_name)
          page.should have_selector('li:nth-child(3)', text: extern_boat_in_own_port.display_name)
        end
      end

      it "should not list invisible boats" do
        within 'nav ul li#boats ul li:nth-child(1) ul' do
          page.should_not have_selector('li', text: own_invisible_boat1.display_name)
          page.should_not have_selector('li', text: own_invisible_boat2.display_name)
        end
      end
    end
  end

  describe "Links to trips" do
    let!(:active_trip) { create(:trip, active: true) }
    let!(:inactive_trip) { create(:trip, active: false) }
    before { visit root_path }

    it "should include a link to every active trip" do      
      page.should have_selector('nav a', text: active_trip.name)
    end
    it "should not include a link to any inactive trip" do
      page.should_not have_selector('nav a', text: inactive_trip.name)
    end
  end
end