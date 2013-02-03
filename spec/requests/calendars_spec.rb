# encoding: utf-8
require 'spec_helper'

describe "Calendar" do
  subject { page }

  describe "boat calendar" do
    year = Date.today.year
    let!(:myself) { create(:boat_owner, is_self: true) }
    let!(:someone_else) { create(:boat_owner, is_self: false) }
    
    # create own boat with trip dates and boat bookings
    let!(:own_checked_boat) { create(:boat, owner: myself) }
    let!(:trip) { create(:trip, boat: own_checked_boat) }
      # unbooked trip date
    let!(:unbooked_trip_date) { create(:trip_date, trip: trip,
      start_at: Date.new(year, 4, 1), end_at: Date.new(year, 4, 7)) }
      # booked trip date
    let!(:booked_trip_date) { create(:trip_date, trip: trip,
      start_at: unbooked_trip_date.end_at + 1.day, end_at: unbooked_trip_date.end_at + 5.days) }
    let!(:trip_booking) { create(:trip_booking, trip_date: booked_trip_date) }
      # trip date that has a cancelled booking
    let!(:cancelled_trip_date) { create(:trip_date, trip: trip,
      start_at: booked_trip_date.end_at + 1.day, end_at: booked_trip_date.end_at + 5.days) }
    let!(:cancelled_trip_booking) { create(:trip_booking, trip_date: cancelled_trip_date,
      cancelled_at: Time.now) }
      # boat booking
    let!(:checked_boat_booking) { create(:boat_booking, 
      boat: own_checked_boat,
      start_at: cancelled_trip_date.end_at + 3.days, end_at: cancelled_trip_date.end_at + 10.days) }

    # create own boat with boat bookings
    let!(:own_unchecked_boat) { create(:boat, owner: myself) }
    let!(:unchecked_boat_booking) { create(:boat_booking, boat: own_unchecked_boat,
      start_at: checked_boat_booking.start_at, end_at: checked_boat_booking.end_at) }

    # create own boat which is not available for boat charter
    let!(:own_no_boat_charter_boat) { create(:bunk_charter_only_boat, owner: myself) }
    let!(:no_boat_charter_trip) { create(:trip, boat: own_no_boat_charter_boat) }
    let!(:no_boat_charter_trip_date) { create(:trip_date, trip: no_boat_charter_trip,
      start_at: checked_boat_booking.start_at, end_at: checked_boat_booking.end_at) }

    # create other boat with boat bookings
    let!(:external_boat) { create(:boat, owner: someone_else) }
    let!(:external_boat_booking) { create(:boat_booking, boat: external_boat,
      start_at: checked_boat_booking.start_at, end_at: checked_boat_booking.end_at) }

    describe "actual calendar" do
      describe "colors" do
        before { visit boat_calendar_path }

        it "should show boat bookings in the color of the corresponding boat" do
          page.find(".ec-boat_booking-#{checked_boat_booking.id}")['style'].should include(checked_boat_booking.boat.color)
        end

        it "should show booked trip dates in the color of the corresponding boat" do
          page.find(".ec-trip_date-#{booked_trip_date.id}")['style'].should 
            include(booked_trip_date.trip.boat.color)
        end
      end

      describe "scope of trip dates" do
        before { visit boat_calendar_path }
        it "should not show unbooked trip dates" do
          page.should_not have_selector(".ec-trip_date-#{unbooked_trip_date.id}")
        end

        it "should not show trip dates with only cancelled bookings" do
          page.should_not have_selector(".ec-trip_date-#{cancelled_trip_date.id}")
        end
      end
      
      describe "without parameters" do
        before { visit boat_calendar_path }

        it "should show booked trip_dates of all own boats available for boat charter" do
          page.should have_selector(".ec-trip_date-#{booked_trip_date.id}")
        end

        it "should show boat bookings of all own boats available for boat charter" do
          page.should have_selector(".ec-boat_booking-#{checked_boat_booking.id}")
          page.should have_selector(".ec-boat_booking-#{unchecked_boat_booking.id}")
        end

        it "should not show trip dates of any own boats not available for boat charter" do
          page.should_not have_selector(".ec-trip_date-#{no_boat_charter_trip_date.id}")
        end

        it "should not show anything of any external boats" do
          page.should_not have_selector(".ec-boat_booking-#{external_boat_booking.id}")
        end
      end

      describe "with parameters" do
        before { select_boats }

        it "should show booked trip_dates with trip name for checked boats" do
          page.should have_selector(".ec-trip_date-#{booked_trip_date.id}")
        end

        it "should show boat bookings for checked boats" do
          page.should have_selector(".ec-boat_booking-#{checked_boat_booking.id}")
        end

        it "should not show anything for unchecked boats" do
          page.should_not have_selector(".ec-boat_booking-#{unchecked_boat_booking.id}")            
        end
      end
    end

    describe "boat selection form" do
      before { select_boats }

      it "should offer selection of own boats" do
        page.should have_selector("#schiffe_#{own_checked_boat.slug}")
        page.should have_selector("#schiffe_#{own_unchecked_boat.slug}")        
      end

      it "should not offer selection of other boats" do
        page.should_not have_selector("#schiffe_#{external_boat.slug}")
      end

      it "should have checked previously checked boats" do
        find("#schiffe_#{own_checked_boat.slug}").should be_checked
      end

      it "should have unchecked previously unchecked boats" do        
        find("#schiffe_#{own_unchecked_boat.slug}").should_not be_checked
      end

      it "should show a preview of the boat color" do
        find(".calendar-selection-item##{own_checked_boat.slug} span")['style'].should include(own_checked_boat.color)
      end
    end

    def select_boats
      visit boat_calendar_path
      check "schiffe_#{own_checked_boat.slug}"
      uncheck "schiffe_#{own_unchecked_boat.slug}"
      click_button "Aktualisieren"
    end
  end

  describe "trip calendar" do

  end


end