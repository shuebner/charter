# encoding: utf-8
require 'spec_helper'

describe "StaticPages" do
  let(:static_page) do 
    create(:static_page, title: "Seite", heading: "Überschrift",
      text: "Hier ist Palve-Charter Müritz")
  end
  subject { page }

  describe "static page should be accessible" do    
    before { visit static_page_path(static_page) }
    
    it { should have_selector('title', text: 'Seite') }
    it { should have_selector('h1', text: 'Überschrift') }
    it { should have_content('Hier ist Palve-Charter Müritz') }
  end

  describe "if static page does not exist" do
    it "should raise a routing error" do
      expect do
        visit static_page_path('bla')
      end.to raise_error(ActionController::RoutingError)
    end
  end

  describe "general page content" do
     
    describe "without heading" do
      let(:static_page_without_heading) { create(:static_page, heading:nil) }
      before { visit static_page_path(static_page_without_heading) }
      it { should_not have_selector('h1') }
    end

    describe "when paragraphs have no heading" do
      let(:paragraph1) do
        create(:paragraph, static_page: static_page, heading: nil)
      end

      before { visit static_page_path(static_page) }

      it { should_not have_selector('h2') }
    end

    describe "with paragraphs" do      
      let!(:paragraph1) { create(:paragraph, static_page: static_page) }
      let!(:paragraph2) { create(:paragraph, static_page: static_page) }
      before { visit static_page_path(static_page) }

      it { should have_selector('h2') }
      it { should have_selector('h2', text: paragraph1.heading) }
      it { should have_selector('p', text: paragraph1.text) }
      
      it { should have_selector('h2', text: paragraph2.heading) }
      it { should have_selector('p', text: paragraph2.text) }
    end

    describe "without paragraphs" do
      it { should_not have_selector('p') }
      it { should_not have_selector('h2') }
    end
  end

  describe "Starting page" do
    let!(:start) { create(:static_page, title: 'Start') }
    describe "in general" do
      before { visit root_path }
      
      it "should be handled separately" do
        page.should have_selector('h1', text: 'Segeln auf der Ostsee')
      end

      it "should contain button directly to blog" do
        within('#content') do
          page.should have_link('Blog', href: 'blog')
        end
      end
    end

    describe "when there are composite trips" do
      let!(:ctrip) { create(:composite_trip) }
      let!(:ctrip_leg) { create(:trip, composite_trip: ctrip) }
      let!(:ctrip_leg_date) { create(:trip_date, trip: ctrip_leg) }
      before { visit root_path }
      it "should contain buttons directly to the active composite trips" do
        within('#content') do
          page.should have_link(ctrip.name, href: composite_trip_path(ctrip))
        end
      end

      describe "which are inactive" do
        before do 
          ctrip.deactivate!
          ctrip.save!
          visit root_path
        end
        it "should not contain buttons to inactive composite trips" do
          within('#content') do
            page.should_not have_link(ctrip.name, href: composite_trip_path(ctrip))
          end
        end
      end
    end
  end
end
