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

  describe "when trip does not exist" do
    it "should raise a routing error" do
      expect do
        visit trip_path('bla')
      end.to raise_error(ActionController::RoutingError)
    end
  end

  describe "show page" do
    let!(:image) { create(:trip_image, attachable: trip) }
    before { visit trip_path(trip) }

    describe "should display information about the trip" do
      it { should have_content(trip.name) }
      it { should have_content(trip.description) }
    end
    describe "images" do
      it "should show the images of the trip with alt text" do
        page.should have_selector('img', src: image.attachment.thumb('300x300').url,
          alt: image.attachment_title)
      end
    end
    it "should show on which boat the trip is available" do
      page.should have_css('#content', text: trip.boat.name)
    end

    describe "trip dates" do
      let!(:date) { create(:trip_date, trip:trip, 
        begin_date: 2.days.from_now, end_date: 3.days.from_now) }
      before { visit trip_path(trip) }
      
      it "should show the dates for the trip" do
        page.should have_content(I18n.l(date.begin_date))
        page.should have_content(I18n.l(date.end_date))
      end
    end
  end
end