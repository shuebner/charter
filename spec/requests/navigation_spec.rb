# encoding: utf-8
require 'spec_helper'

describe "Navigation" do
  let!(:root_page) do
    StaticPage.create!(title: 'Start', 
      heading: 'Willkommen', text: 'Hier ist Palve-Charter Müritz')
  end
  subject { page }

  describe "Links to boats" do
    let!(:available_active_boat) { create(:boat) }
    let!(:unavailable_active_boat) { create(:unavailable_boat) }
    let!(:available_inactive_boat) { create(:boat, active: false) }
    before { visit root_path }
    
    it "should include a link to every visible boat" do
      page.should have_selector('a', text: available_active_boat.name)
    end
    it "should not include a link to any invisible boat" do
      page.should_not have_selector('a', text: unavailable_active_boat.name)
      page.should_not have_selector('a', text: available_inactive_boat.name)
    end
  end

  describe "Links to trips" do
    let!(:trip) { create(:trip) }    
    before { visit root_path }

    describe "should include a link to every trip" do
      it { should have_selector('a', text: trip.name) }
    end
  end
end