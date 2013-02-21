# encoding: utf-8
require 'spec_helper'
require 'support/inquiries_request'
require 'inquiry_form_helper'

describe "BoatInquiries" do
  include InquiryFormHelper

  subject { page }

  describe "boat inquiry" do
    let(:boat) { create(:boat, name: "Palve") }
    before do
      visit new_boat_inquiry_path(boat: boat.slug)
    end

    let(:additional_form_actions) do
      lambda do |page|
        page.fill_in "boat_inquiry_begin_date", with: "01.07.2013"
        page.fill_in "boat_inquiry_end_date", with: "07.07.2013"        
        page.select 2.to_s, from: "boat_inquiry_adults"
        page.select 1.to_s, from: "boat_inquiry_children"
      end
    end

    # hässliches Wiederholen, damit it_behaves_like auf additional_form_actions zugreifen kann
    @additional_form_actions =
      lambda do |page|
        page.fill_in "boat_inquiry_begin_date", with: "01.07.2013"
        page.fill_in "boat_inquiry_end_date", with: "07.07.2013"        
        page.select 2.to_s, from: "boat_inquiry_adults"
        page.select 1.to_s, from: "boat_inquiry_children"
      end
    
    it_behaves_like 'inquiries request', BoatInquiry, :boat_inquiry, 
      @additional_form_actions

    it "should show the right boat" do
      page.should have_selector('p', text: boat.name)
      page.should have_selector('h2', text: boat.name)
    end

    describe "on valid form submit" do
      it "should show success page with link to inquired boat" do
        fill_in_and_submit_form(additional_form_actions)
        within '#content' do
          page.should have_link(boat.name, href: boat_path(boat))
        end
      end
    end
  end
end