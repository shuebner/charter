# encoding: utf-8
require 'spec_helper'

describe "Trips" do
  let!(:trip) { create(:trip) }

  subject { page }

  describe "index page" do
    let!(:inactive_trip) { create(:trip, active: false) }
    before { visit trips_path }

    it "should display all active trips" do
      page.should have_selector('#content', text: trip.name)
    end
    it "should not display inactive trips" do
      page.should_not have_selector('#content', text: inactive_trip.name)
    end
  end

  describe "show page" do
    describe "when trip does not exist" do
      it "should raise a routing error" do
        expect do
          visit trip_path('bla')
        end.to raise_error(ActionController::RoutingError)
      end
    end
    describe "when trip is not visible" do
      let!(:inactive_trip) { create(:trip, active: false) }
      it "should raise a routing error" do
        expect do
          visit trip_path(inactive_trip)
        end.to raise_error(ActionController::RoutingError)
      end
    end

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
        start_at: 2.days.from_now, end_at: 3.days.from_now) }
      before { visit trip_path(trip) }
      
      it "should show the dates for the trip" do
        page.should have_content(I18n.l(date.start_at))
        page.should have_content(I18n.l(date.end_at))
      end

      describe "links to trip inquiries" do
        let!(:full_date) { create(:trip_date, trip: trip) }
        let!(:full_booking) { create(:trip_booking, trip_date: full_date, 
          no_of_bunks: full_date.no_of_available_bunks) }
        before { visit trip_path(trip) }
        it "should have a link to the right trip inquiry form for non-full trips" do
          page.should have_link("buchen", href: new_trip_inquiry_path(trip_date_id: date.id))
        end
        it "should not have a link to an inquiry for full trips" do
          page.should_not have_link("buchen", href: new_trip_inquiry_path(trip_date_id: full_date.id))
        end
      end
    end
  end
end