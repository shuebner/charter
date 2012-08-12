# encoding: utf-8
require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "home page" do
    before do 
      StaticPage.create!(name: 'start', title: 'Willkommen', 
        heading: 'Start', text: 'Hier ist Palve-Charter Müritz')
      visit root_path
    end
    
    it { should have_selector('title', text: 'Willkommen') }
    it { should have_selector('h1', text: 'Start') }
    it { should have_content('Hier ist Palve-Charter Müritz') }
  end

  describe "area page" do
    before do
      StaticPage.create!(name: 'revier', title: 'Revier',
        heading: 'Revier', text: 'Mecklenburgische Seenplatte')
      visit area_path
    end

    it { should have_selector('title', text: 'Revier') }
    it { should have_selector('h1', text: 'Revier') }
    it { should have_content('Mecklenburgische Seenplatte') }
  end

  describe "trip page" do
    before do
      StaticPage.create!(name: 'toerns', title: 'Törns',
        heading: 'Törns', text: 'Törnvorschläge für die Müritz')
      visit trips_path
    end

    it { should have_selector('title', text: 'Törns') }
    it { should have_selector('h1', text: 'Törns') }
    it { should have_content('Törnvorschläge für die Müritz') }
  end

  describe "imprint page" do
    before do
      StaticPage.create!(name: 'impressum', title: 'Impressum',
        heading: 'Impressum', text: 'Klaus Wenz<br>Palve-Charter')
      visit imprint_path
    end

    it { should have_selector('title', text: 'Impressum') }
    it { should have_selector('h1', text: 'Impressum') }
    it { should have_content('Klaus Wenz<br>Palve-Charter') }
  end 
end
