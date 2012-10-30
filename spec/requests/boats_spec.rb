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

    describe "when boat is not visible" do
      let!(:invisible_boat) { create(:unavailable_boat) }
      it "should not be available" do        
        expect do
          visit boat_path(invisible_boat)
        end.to raise_error(ActionController::RoutingError)
      end
    end        

    describe "boat section" do
      before { visit boat_path(boat) }
      
      describe "should display information about the boat" do
        it { should have_content(boat.name) }
        it { should have_content(boat.manufacturer) }
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
  end
end