# encoding: utf-8
require 'spec_helper'

describe "Boats" do
  subject { page }

  describe "index page" do
    let!(:visible_boat) { create(:boat) }
    let!(:invisible_boat) { create(:unavailable_boat) }
    before { visit boats_path }

    describe "should display all visible boats" do
      it { should have_content(visible_boat.name) }
    end

    describe "should not display any invisible boats" do      
      it { should_not have_content(invisible_boat.name) }
    end
  end


  describe "show page" do
    let!(:boat) { create(:boat) }
    let!(:image) { create(:boat_image, attachable: boat) }
    
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
        
=begin        let!(:early_price) do 
          create(:boat_price, season: early_season, boat_price_type: weekend,
            boat: boat) }
        end
        let!(:main_price) do
          create(:boat_price, season: main_season, boat_price_type: weekend,
            boat: boat)
        end
        let!(:late_price do
          create(:boat_price, season: late_season, boat_price_type: weekend,
            boat: boat)
        end
=end        
        it "should contain the names of all seasons" do
          Season.all.each do |s|
            page.should have_selector('table th', text: s.name)
          end
        end
        it "should contain the names of all boat price types" do
          BoatPriceType.all.each do |t|
            page.should have_selector('table tr', text: t.name)
          end
        end
        it "should contain all boat charter prices of this boat" do
          boat.boat_prices.each do |p|
            page.should have_selector('table tr', text: number_to_currency(p.value))
          end
        end
      end
    end
  end
end