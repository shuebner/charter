# encoding: utf-8
require 'spec_helper'

describe "Boats" do
  subject { page }

  describe "index page" do
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
    # Hafen mit ausschließlich fremden Schiffen
    let!(:other_port_with_visible_boat2) { create(:port, name: "Xanten") }
    let!(:other_visible_boat2_1) { create(:boat, 
      owner: someone_else, port: other_port_with_visible_boat2) }

    # Hafen mit eigenen ausschließlich unsichtbaren Schiffen und sichtbaren fremden Schiffen
    let!(:other_port_with_visible_boat1) { create(:port, name: "Azeroth") }
    let!(:other_visible_boat1_1) { create(:boat, 
      owner: someone_else, port: other_port_with_visible_boat1) }
    let!(:own_invisible_own_boat1_1) { create(:boat,
      owner: myself, port: other_port_with_visible_boat1, active: false) }

    # Hafen ohne verfügbares Boot
    let!(:port_without_visible_boat) { create(:port) }
    let!(:invisible_boat) { create(:unavailable_boat, port: port_without_visible_boat) }
    
    # fremdes Schiff in eigenem Hafen
    let!(:extern_boat_in_own_port) { create(:boat,
      owner: someone_else, port: own_port_with_visible_boat, model: "ZZZ") }

    before { visit boats_path }

    it "should show own ports first, then other ports in alphabetical order by model" do
      within "ul.port-list" do
        page.should have_selector('li:nth-child(1)', text: own_port_with_visible_boat.name)
        page.should have_selector('li:nth-child(2)', text: other_port_with_visible_boat1.name)
        page.should have_selector('li:nth-child(3)', text: other_port_with_visible_boat2.name)
      end
    end

    it "should not display ports without visible boats" do
      within 'ul.port-list' do
        page.should_not have_content(port_without_visible_boat.name)
      end
    end

    it "should not show ports with own and external boats twice" do
      within "ul.port-list" do
        page.all('li', text: own_port_with_visible_boat.name).count.should == 1
      end
    end

    describe "for a given port" do
      it "should display all visible boats with this port in alphabetical order by model" do
        within 'ul.port-list li:nth-child(1) ul.boat-list' do
          page.should have_selector('li:nth-child(1)', text: own_visible_boat1.name)
          page.should have_selector('li:nth-child(2)', text: own_visible_boat2.name)
          page.should have_selector('li:nth-child(3)', text: extern_boat_in_own_port.name)
        end
      end

      it "should not display invisible boats with this port" do
        within 'ul.port-list li:nth-child(1) ul.boat-list' do
          page.should_not have_content(own_invisible_boat1.name)
          page.should_not have_content(own_invisible_boat2.name)
        end
      end
    end

    describe "with parameter hafen" do
      before { visit boats_path(hafen: own_port_with_visible_boat.slug) }
      it "should show visible boats from that port" do
        within 'ul.boat-list' do
          page.should have_selector('li:nth-child(1)', text: own_visible_boat1.name)
          page.should have_selector('li:nth-child(2)', text: own_visible_boat2.name)
          page.should have_selector('li:nth-child(3)', text: extern_boat_in_own_port.name)
        end
      end
      
      it "should not show other ports" do
        within '#content' do
          page.should_not have_selector('li', text: other_port_with_visible_boat1.name)
          page.should_not have_selector('li', text: other_port_with_visible_boat2.name)
        end
      end

      describe "link to boat calendar" do
        describe "if port is own port" do
          before { visit boats_path(hafen: own_port_with_visible_boat.slug) }
          it "should be present" do
            within '#content' do
              page.should have_link('Buchungskalender')
            end
          end
          it "should pre-select the own boats of this port" do
            within '#content' do
              page.should have_link('Buchungskalender', href: boat_calendar_path(
                schiffe: Hash[own_port_with_visible_boat.boats.own.visible.
                  boat_charter_only.map { |b| [b.slug, b.slug]}]))
            end
          end
        end

        describe "if port is external port" do
          before { visit boats_path(hafen: other_port_with_visible_boat1) }
          it "should not be present" do
            within '#content' do
              page.should_not have_link('Buchungskalender', href: boat_calendar_path)
            end
          end
        end
      end
    end
  end


  describe "show page" do
    let!(:boat) { create(:boat) }
    let!(:image) { create(:boat_image, attachable: boat) }

    describe "with invalid parameters" do
      describe "when boat does not exist" do
        it "should cause routing error" do
          expect do
            visit "#{boats_path}/gibtsnicht"
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe "when boat is not available" do
        let!(:invisible_boat) { create(:unavailable_boat) }
        it "should cause routing error" do        
          expect do
            visit boat_path(invisible_boat)
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe "when boat is not active" do
        let!(:inactive_boat) { create(:boat, active: false) }
        it "should cause routing error" do
          expect do
            visit boat_path(inactive_boat)
          end.to raise_error(ActionController::RoutingError)
        end
      end
    end

    describe "boat section" do
      before { visit boat_path(boat) }
      
      describe "should display information about the boat" do
        it { should have_content(boat.name) }
        it { should have_content(boat.manufacturer) }
      end

      describe "images" do
        it "should show the images of the boat with alt text" do
          page.should have_selector('img', src: image.attachment.thumb('300x300').url,
            alt: image.attachment_title)
        end
      end
    end

    describe "trip section" do
      
      describe "should show available trips for the boat" do
        let!(:trip) { create(:trip, boat: boat) }
        before { visit boat_path(boat) }      

        it { should have_selector('h2', text: 'Törns') }
        it { should have_content(trip.name) }
      end
    end

    describe "should not show trips when none are available" do
      before { visit boat_path(boat) }

      it { should_not have_selector('h2', text: 'Törns') }
    end

    describe "boat charter section" do
      describe "prices" do
        let!(:early_season) { create(:early_season) }
        let!(:main_season) { create(:main_season) }
        let!(:late_season) { create(:late_season) }
        
        let!(:weekend) { create(:boat_price_type, 
          name: "Wochenendcharter", duration: 2) }
        let!(:week) { create(:boat_price_type,
          name: "Wochencharter", duration: 7) }

        before do
          Season.all.each do |s|
            BoatPriceType.all.each do |t|
              create(:boat_price, boat: boat, season: s, boat_price_type: t)
            end
          end
          visit boat_path(boat)
        end

        it "should contain the names of all seasons" do
          Season.all.each do |s|
            page.should have_selector('table tr', text: s.name)
          end
        end
        it "should contain the names of all boat price types" do
          BoatPriceType.all.each do |t|
            page.should have_selector('table th', text: t.name)
          end
        end
        it "should contain all boat charter prices of this boat" do
          boat.boat_prices.each do |p|
            page.should have_selector('table tr', text: number_to_currency(p.value))
          end
        end

        it "should contain link to boat inquiry form" do
          page.should have_link("buchen", href: new_boat_inquiry_path(boat: boat.slug))
        end
      end

      describe "accessory charges" do
        let(:boat) { create(:boat_charter_only_boat) }
        before { visit boat_path(boat) }
        [:deposit, :cleaning_charge, :gas_charge].each do |c|
          it "should contain the #{c.to_s}" do
            page.should have_selector('table td', text: number_to_currency(boat[c]) )
          end
        end
        it "should contain the fuel_charge" do
          page.should have_selector('small', text: number_to_currency(boat.fuel_charge))
        end
      end


      
      describe "of own boat" do
        let(:myself) { create(:boat_owner, is_self: true) }      
        let(:own_boat) { create(:boat, owner: myself) }
        before { visit boat_path(own_boat) }
        
        it "should have a link to the calendar of the boat" do
          page.should have_selector("a[href='"\
            "#{boat_calendar_path(schiffe: { own_boat.slug => own_boat.slug })}']")
        end
      end
      describe "of external boat" do
        let(:someone_else) { create(:boat_owner, is_self: false) }      
        let(:other_boat) { create(:boat, owner: someone_else) }
        before { visit boat_path(other_boat) }

        it "should not have a link to the calendar of the boat" do
          page.should_not have_selector("a[href='"\
            "#{boat_calendar_path(schiffe: { other_boat.slug => other_boat.slug })}']")
        end
      end
    end

    describe "should not show charter section when boat is not available for boat charter" do
      let!(:no_boat_charter_boat) { create(:bunk_charter_only_boat) }
      before { visit boat_path(no_boat_charter_boat) }
      it { should_not have_selector('h2', 'Schiffscharter') }
    end

    describe "documents section" do
      
      describe "when there are some" do
        let!(:document) { create(:document, attachable: boat) }
        before { visit boat_path(boat) }
        
        it "should show the document title" do
          page.should have_content(document.title)
        end
        
        it "should provide a link to the document" do
          page.should have_selector('a', href: document.url)
        end
      end

      describe "when there are none" do
        before do
          boat.documents.each(&:destroy)
          visit boat_path(boat)
        end
        it "should not show the document section" do
          page.should_not have_content('Dokumente')
        end
      end
    end
  end
end 
