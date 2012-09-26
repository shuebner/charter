# encoding: utf-8
require 'spec_helper'

describe "Boats" do

  let!(:visible_boat1) { create(:boat,
    name: "SS Sichtbar1", available_for_boat_charter: true) }
  let!(:visible_boat2) { create(:boat,
    name: "SS Sichtbar2", available_for_boat_charter: true) }    
  let!(:invisible_boat) { create(:boat,
    name: "SS Unsichtbar", available_for_boat_charter: false) }



  subject { page }

  describe "index page" do

    before { visit boats_path }

    describe "should display all visible boats" do
      it { should have_content(visible_boat1.name) }
      it { should have_content(visible_boat2.name) }
    end

    describe "should not display any invisible boats" do      
      it { should_not have_content(invisible_boat.name) }
    end
  end


  describe "show page" do

    before { visit boat_path(visible_boat1) }

    describe "should display information about the boat and its type" do
      it { should have_content(visible_boat1.name) }
      it { should have_content(visible_boat1.manufacturer) }
    end
  end
end