# encoding: utf-8
require 'spec_helper'

describe "Boats" do
  subject { page }

  describe "index page" do
    let!(:captain1) { create(:captain) }
    let!(:captain2) { create(:captain) }
    before { visit captains_path }
    describe "should display all captains" do
      it { should have_content(captain1.full_name) }
      it { should have_content(captain2.full_name) }
    end      
  end
end