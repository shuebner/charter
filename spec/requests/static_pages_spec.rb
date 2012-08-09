# encoding: utf-8
require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "home page" do
    before do 
      StaticPage.create(name: 'start', title: 'Willkommen', 
        heading: 'Start', text: 'Hier ist Palve-Charter Müritz')
      visit root_path
    end
    
    it { should have_selector('title', text: 'Willkommen') }
    it { should have_selector('h1', text: 'Start') }
    it { should have_content('Hier ist Palve-Charter Müritz') }
  end
end
