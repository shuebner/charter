# encoding: utf-8
require 'spec_helper'

describe "Trips" do
  let!(:trip) { create(:trip) }

  subject { page }

  describe "index page" do
    before { visit trips_path }

    describe "should display all trips" do
      it { should have_content(trip.name) }
    end
  end

  describe "show page" do
    before { visit trip_path(trip) }

    describe "should display information about the trip" do
      it { should have_content(trip.name) }
      it { should have_content(trip.description) }
    end

    it "should show on which boat the trip is available" do
      page.should have_css('#content', text: trip.boat.name)
    end
  end
end