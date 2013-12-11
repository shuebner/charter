# encoding: utf-8
require 'spec_helper'
require 'database_cleaner'

describe "Trips" do

  let!(:trip) { create(:trip, name: "Zamonien") }

  subject { page }

  describe "index page" do

    describe "without parameter" do
      let!(:inactive_trip) { create(:trip, active: false) }
      let!(:composite_trip) { create(:composite_trip, name: "Finsterwald") }
      let!(:previous_composite_trip) { create(:composite_trip, name: "Buntbärenwald" )}
      let!(:trip_for_composite_trip) { create(:trip_for_composite_trip,
        composite_trip: composite_trip) }
      let!(:inactive_composite_trip) { create(:composite_trip, active: false) }
      let!(:previous_trip) { create(:trip, name: "Azeroth") }
      before { visit trips_path }

      it "should display all active trips at the bottom ordered ascending by name" do
        within "#content ul.trip-list" do
          page.should have_selector('li:nth-child(3)', text: previous_trip.name)
          page.should have_selector('li:nth-child(4)', text: trip.name)
        end
      end
      it "should not display inactive trips" do
        within "#content ul.trip-list" do
          page.should_not have_selector('li', text: inactive_trip.name)
        end
      end
      it "should not display trips which belong to a composite trip" do
        within "#content ul.trip-list" do
          page.should_not have_selector('>li', text: trip_for_composite_trip.name)
        end
      end
      it "should display active composite trips at the top ascending by name" do
        within "#content ul.trip-list" do
          page.should have_selector('li:nth-child(1)', text: previous_composite_trip.name)
          page.should have_selector('li:nth-child(2)', text: composite_trip.name)
        end
      end
      it "should not display inactive composite trips" do
        within "#content ul.trip-list" do
          page.should_not have_selector('li', text: inactive_composite_trip.name)
        end
      end
    end

    describe "with parameter boat" do        
      describe "which is invalid" do        
        let(:no_bunk_charter_boat) { FactoryGirl.create(:boat_charter_only_boat) }
        let(:inactive_boat) { FactoryGirl.create(:boat, active: false) }
        it "should cause a routing error" do
          [ { reason: "because boat does not exist", slug: 'gibts nicht' },
            { reason: "because boat is not available for bunk charter", slug: no_bunk_charter_boat.slug },
            { reason: "because boat is inactive", slug: inactive_boat.slug }].each do |t|    
            expect do
              visit trips_path(schiff: t[:slug])
            end.to raise_error(ActionController::RoutingError)
          end
        end
      end

      describe "for valid boat" do
        let!(:trip_with_other_boat) { create(:trip) }
        before { visit trips_path(schiff: trip.boat.slug) }
        it "should show trips with this boat" do
          within '#content ul.trip-list' do
            page.should have_selector('li', text: trip.name)
          end        
        end
        it "should not show trips with other boats" do
          within '#content ul.trip-list' do
            page.should_not have_selector('li', text: trip_with_other_boat.name)
          end
        end
        it "should link to the boat in question" do
          within '#content' do
            page.should have_link(trip.boat.name, href: boat_path(trip.boat))
          end
        end
      end
    end
  end

  describe "show page" do
    describe "with invalid parameters" do
      describe "when trip does not exist" do
        it "should raise a routing error" do
          expect do
            visit trip_path('bla')
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe "when trip is not active" do
        let!(:inactive_trip) { create(:trip, active: false) }
        it "should raise a routing error" do
          expect do
            visit trip_path(inactive_trip)
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe "when trip belongs to composite trip" do
        let!(:composite_trip) { create(:composite_trip) }
        let!(:trip_for_composite_trip) { create(:trip_for_composite_trip,
          composite_trip: composite_trip) }
        it "should raise a routing error" do
          expect do
            visit trip_path(trip_for_composite_trip)
          end.to raise_error(ActionController::RoutingError)
        end
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
      let!(:start_at) { create(:setting, key: 'current_period_start_at', value: I18n.l(Date.new(2014, 1, 1))) }
      let!(:end_at) { create(:setting, key: 'current_period_end_at', value: I18n.l(Date.new(2014, 12, 31))) }
      let!(:date) { create(:trip_date, trip: trip, 
        start_at: Setting.current_period_start_at + 1.day, end_at: Setting.current_period_start_at + 5.days) }
      let!(:deferred_date) { create(:deferred_trip_date, trip: trip,
        start_at: Setting.current_period_start_at + 6.days, end_at: Setting.current_period_start_at + 9.days) }
      let!(:date_outside_current_period) { create(:trip_date, trip: trip,
        start_at: Setting.current_period_end_at + 2.days, end_at: Setting.current_period_end_at + 6.days) }
      before { visit trip_path(trip) }
      
      it "should show the dates for the trips in the current period" do
        [date, deferred_date].each do |td|
          within "#trip-dates #trip-date-#{td.id}" do        
            page.should have_selector(".start-at", text: I18n.l(td.start_at))
            page.should have_selector(".end-at", text: I18n.l(td.end_at))
          end
        end
      end

      it "should not show dates for the trips outside of the current period" do
        within "#trip-dates" do
          page.should_not have_selector("#trip-date-#{date_outside_current_period.id}")
        end
      end

      describe "the number of available bunks" do
        it "for undeferred trip dates should be the actual number of available bunks" do
          within "#trip-dates #trip-date-#{date.id}" do
            page.should have_selector(".available-bunks", text: "#{date.no_of_available_bunks}")
          end
        end

        it "for deferred trip dates should be zero" do
          within "#trip-dates #trip-date-#{deferred_date.id}" do
            page.should_not have_selector(".available-bunks", text: "#{deferred_date.no_of_available_bunks}")
            page.should have_selector(".available-bunks", text: "0")
          end
        end
      end

      describe "links to trip inquiries" do
        let!(:full_date) { create(:trip_date, start_at: date.end_at + 1.day, end_at: date.end_at + 5.days, trip: trip) }
        let!(:full_booking) { create(:trip_booking, trip_date: full_date, 
          no_of_bunks: full_date.no_of_available_bunks) }
        before { visit trip_path(trip) }
        it "should have a link to the right trip inquiry form for non-full trip dates" do
          page.should have_link("buchen", href: new_trip_inquiry_path(trip_date_id: date.id))
        end
        it "should not have a link to an inquiry for full trip dates" do
          page.should_not have_link("buchen", href: new_trip_inquiry_path(trip_date_id: full_date.id))
        end
        it "should not have a link to an inquiry for deferred trip dates" do
          page.should_not have_link("buchen", href: new_trip_inquiry_path(trip_date_id: deferred_date.id))
        end
      end
    end
  end
end