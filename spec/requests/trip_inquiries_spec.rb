# encoding: utf-8
require 'spec_helper'
require 'support/inquiries_request'
require 'inquiry_form_helper'

describe "TripInquiries" do
  include InquiryFormHelper

  subject { page }

  describe "trip inquiry" do
    let(:trip) { create(:trip, no_of_bunks: 4) }
    let!(:trip_date) { create(:trip_date, trip: trip) }
    before do
      visit new_trip_inquiry_path(trip_date_id: trip_date.id)
    end

    let(:additional_form_actions) do
      lambda { |page| page.select "1", from: 'Kojenzahl' }
    end

    # hässliches Wiederholen, damit it_behaves_like auf additional_form_actions zugreifen kann
    @additional_form_actions =
      lambda { |page| page.select "1", from: 'Kojenzahl' }
    
    it_behaves_like 'inquiries request', TripInquiry, :trip_inquiry, 
      @additional_form_actions
    
    it "should show the right trip date" do
      page.should have_selector('p', text: trip_date.display_name_with_trip)
      page.should have_selector('h2', text: trip_date.display_name_with_trip)
    end

    describe "on valid form submit" do
      it "should show success page with link to inquired trip" do
        fill_in_and_submit_form(additional_form_actions)
        within '#content' do
          page.should have_link(trip.name, href: trip_path(trip))
        end
      end
    end
  end
end