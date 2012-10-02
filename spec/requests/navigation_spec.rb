# encoding: utf-8
require 'spec_helper'

describe "Navigation" do
  let!(:boat) { create(:boat) }
  let!(:root_page) do
    StaticPage.create!(slug: 'start', title: 'Willkommen', 
      heading: 'Start', text: 'Hier ist Palve-Charter Müritz')
  end
  subject { page }

  describe "Links to boats" do
    before { visit root_path }
    describe "should include a link to every visible boat" do
      it { should have_selector('a', text: boat.name) }
    end
  end
end