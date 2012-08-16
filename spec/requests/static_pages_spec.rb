# encoding: utf-8
require 'spec_helper'

describe "StaticPages" do
  
  subject { page }

  describe "home page should be accessible" do    
    before do 
      StaticPage.create!(name: 'start', title: 'Willkommen', 
        heading: 'Start', text: 'Hier ist Palve-Charter Müritz')
      visit root_path
    end
    
    it { should have_selector('title', text: 'Willkommen') }
    it { should have_selector('h1', text: 'Start') }
    it { should have_content('Hier ist Palve-Charter Müritz') }
  end

  describe "area page should be accessible" do
    before do
      StaticPage.create!(name: 'revier', title: 'Revier',
        heading: 'Revier', text: 'Mecklenburgische Seenplatte')
      visit area_path
    end

    it { should have_selector('title', text: 'Revier') }
    it { should have_selector('h1', text: 'Revier') }
    it { should have_content('Mecklenburgische Seenplatte') }
  end

  describe "trip page should be accessible" do
    before do
      StaticPage.create!(name: 'toerns', title: 'Törns',
        heading: 'Törns', text: 'Törnvorschläge für die Müritz')
      visit trips_path
    end

    it { should have_selector('title', text: 'Törns') }
    it { should have_selector('h1', text: 'Törns') }
    it { should have_content('Törnvorschläge für die Müritz') }
  end

  describe "imprint page should be accessible" do
    before do
      StaticPage.create!(name: 'impressum', title: 'Impressum',
        heading: 'Impressum', text: 'Klaus Wenz<br>Palve-Charter')
      visit imprint_path
    end

    it { should have_selector('title', text: 'Impressum') }
    it { should have_selector('h1', text: 'Impressum') }
    it { should have_content('Klaus Wenz') }
  end

  describe "invalid page request" do
    it "should raise a routing exception" do
      lambda do
        visit 'ungueltig'
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe "general page content" do
     
    describe "without heading" do
      before do
        FactoryGirl.create(:static_page, heading: nil)
        visit start_path
      end

      it { should_not have_selector('h1') }
    end

    describe "when paragraphs have no heading" do
      let!(:static_page) { FactoryGirl.create(:static_page, text: nil) }
      let!(:paragraph1) do
        FactoryGirl.create(:paragraph, static_page: static_page, heading: nil)
      end

      before { visit start_path }

      it { should_not have_selector('h2') }
    end

    describe "with paragraphs" do      
      let!(:static_page) { FactoryGirl.create(:static_page, text: nil) }
      let!(:paragraph1) { FactoryGirl.create(:paragraph, static_page: static_page) }
      let!(:paragraph2) { FactoryGirl.create(:paragraph, static_page: static_page) }
      before { visit start_path }

      it { should have_selector('h2') }
      it { should have_selector('h2', text: paragraph1.heading) }
      it { should have_selector('p', text: paragraph1.text) }
      
      it { should have_selector('h2', text: paragraph2.heading) }
      it { should have_selector('p', text: paragraph2.text) }
    end

    describe "without paragraphs" do
      let(:static_page) { FactoryGirl.create(:static_page, text: nil) }
      it { should_not have_selector('p') }
      it { should_not have_selector('h2') }
    end
  end
end
