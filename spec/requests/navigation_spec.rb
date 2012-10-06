# encoding: utf-8
require 'spec_helper'

describe "Navigation" do
  let!(:root_page) do
    StaticPage.create!(title: 'Start', 
      heading: 'Willkommen', text: 'Hier ist Palve-Charter Müritz')
  end
  subject { page }

  describe "Links to boats" do
    let!(:boat) { create(:boat) }
    before { visit root_path }
    
    describe "should include a link to every visible boat" do
      it { should have_selector('a', text: boat.name) }
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