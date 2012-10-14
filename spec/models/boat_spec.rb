# encoding: utf-8

require 'spec_helper'

describe Boat do
  let(:boat) { create(:boat) }

  subject { boat }

  it { should respond_to(:manufacturer) }
  it { should respond_to(:model) }
  it { should respond_to(:length_hull) }
  it { should respond_to(:length_waterline) }
  it { should respond_to(:beam) }
  it { should respond_to(:draft) }
  it { should respond_to(:air_draft) }
  it { should respond_to(:displacement) }
  it { should respond_to(:sail_area_jib) }
  it { should respond_to(:sail_area_genoa) }
  it { should respond_to(:sail_area_main_sail) }
  it { should respond_to(:tank_volume_diesel) }
  it { should respond_to(:tank_volume_fresh_water) }
  it { should respond_to(:tank_volume_waste_water) }
  it { should respond_to(:permanent_bunks) }
  it { should respond_to(:convertible_bunks) }
  it { should respond_to(:max_no_of_people) }
  it { should respond_to(:recommended_no_of_people) }
  it { should respond_to(:headroom_saloon) }
  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:year_of_construction) }
  it { should respond_to(:year_of_refit) }
  it { should respond_to(:engine_manufacturer) }
  it { should respond_to(:engine_model) }
  it { should respond_to(:engine_design) }
  it { should respond_to(:engine_output) }
  it { should respond_to(:battery_capacity) }
  it { should respond_to(:available_for_boat_charter) }
  it { should respond_to(:available_for_bunk_charter) }
  it { should respond_to(:deposit) }
  it { should respond_to(:cleaning_charge) }
  it { should respond_to(:fuel_charge) }
  it { should respond_to(:gas_charge) }

  it { should be_valid }
  
  describe "when manufacturer is not present" do
    before { boat.manufacturer = nil }
    it { should_not be_valid }
  end

  describe "when model is not present" do
    before { boat.model = nil }
    it { should_not be_valid }
  end

  describe "when name is empty" do
    before { boat.name = nil }
    it { should_not be_valid }
  end

  describe "when slug is empty" do
    let!(:boat_without_slug) do 
      build(:boat, name: "Testschiff Bla 2", slug: nil)
    end

    subject { boat_without_slug }

    describe "upon saving the slug should be automatically added" do
      before { boat_without_slug.save! }
      it { should be_valid }
      its(:slug) { should == "testschiff-bla-2" }    
    end
  end

  describe "when year_of_construction is empty" do
    before { boat.year_of_construction = nil }
    it { should_not be_valid }
  end

  describe "when available_for_boat_charter is empty" do
    before { boat.available_for_boat_charter = nil }
    it { should_not be_valid }
  end

  describe "when available_for_bunk_charter is empty" do
    before { boat.available_for_bunk_charter = nil}
    it { should_not be_valid }
  end

  describe "when boat is not available for boat charter" do
    let!(:no_boat_charter_boat) { build(:bunk_charter_only_boat) }
    subject { no_boat_charter_boat }

    describe "and charges are given" do
      it "it should not be valid" do
        [:deposit, :cleaning_charge, :fuel_charge, :gas_charge].each do |a|
          no_boat_charter_boat[a] = 100
          no_boat_charter_boat.should_not be_valid
          no_boat_charter_boat[a] = nil
        end
      end
    end
  end

  describe "when boat is available for boat charter" do
    let!(:boat_for_boat_charter) { build(:boat, available_for_boat_charter: true) }
    subject { boat_for_boat_charter }

    describe "and any charge is missing (except for gas charge)" do
      before do
        [:deposit, :cleaning_charge, :fuel_charge].each do |a|
          boat_for_boat_charter[a] = 100
        end
      end
      it "it should not be valid" do
        [:deposit, :cleaning_charge, :fuel_charge].each do |a|
          boat_for_boat_charter[a] = nil
          boat_for_boat_charter.should_not be_valid
          boat_for_boat_charter[a] = 100
        end
      end
    end
  end

  describe "calculated field" do
    
    describe "sail area fields" do
      before { boat.sail_area_main_sail = 10 }
      
      describe "with all necessary areas given" do
        before do 
          boat.sail_area_jib = 1
          boat.sail_area_genoa = 3
        end
        its(:total_sail_area_with_jib) { should == 11 }        
        its(:total_sail_area_with_genoa) { should == 13 }
      end
      describe "without all necessay areas given" do
        before do 
          boat.sail_area_jib = nil
          boat.sail_area_genoa = nil
        end
        it "should not raise an error" do
          lambda { boat.total_sail_area_with_jib }.should_not raise_error          
          lambda { boat.total_sail_area_with_genoa }.should_not raise_error
        end          
        its(:total_sail_area_with_jib) { should be_nil }
        its(:total_sail_area_with_genoa) { should be_nil }
      end
    end
    
    describe "visible?" do
      describe "should be true if boat is available for boat charter" do
        before do
          boat.available_for_boat_charter = true
          boat.available_for_bunk_charter = false
        end
        it { should be_visible }
      end
      describe "should be true if boat is available for bunk charter" do
        before do
          boat.available_for_boat_charter = false
          boat.available_for_bunk_charter = true
        end
        it { should be_visible }
      end
      describe "should be false if boat is available for NEITHER boat NOR bunk charter" do
        before do
          boat.available_for_bunk_charter = false
          boat.available_for_boat_charter = false
        end
        it { should_not be_visible }
      end
    end

    describe "max_no_of_bunks should be sum of permanent and convertible bunks" do
      before do
        boat.permanent_bunks = 4
        boat.convertible_bunks = 2
      end
      its(:max_no_of_bunks) { should == 6 }
    end
  end

  describe "scope" do
    describe "visible" do
      let(:visible_boat1) { create(:boat) }
      let(:visible_boat2) { create(:bunk_charter_only_boat) }
      let(:visible_boat3) { create(:boat_charter_only_boat) }
      let(:invisible_boat) { create(:unavailable_boat) }
      it "should contain all visible boats" do
        Boat.visible.should include(visible_boat1, visible_boat2, visible_boat3)        
      end
      it "should not contain any invisible boat" do
        Boat.visible.should_not include(invisible_boat)
      end
    end

    describe "bunk_charter_only" do
      let(:boat_for_bunk_charter) { create(:bunk_charter_only_boat) }
      let(:boat_not_for_bunk_charter) { create(:boat_charter_only_boat) }
      it "should contain all boats available for bunk charter" do
        Boat.bunk_charter_only.should include(boat_for_bunk_charter)
      end
      it "should not contain any boat not available for bunk charter" do
        Boat.bunk_charter_only.should_not include(boat_not_for_bunk_charter)
      end
    end
  end

  describe "default sort order" do
    let!(:second_boat) { create(:boat, name: "ZZZ") }
    let!(:first_boat) { create(:boat, name: "AAA") }
    
    it "should sort ascending by name" do
      Boat.all.should == [first_boat, second_boat]
    end
  end

  describe "trip association" do
    describe "with boat available for bunk charter" do
      let!(:boat_for_bunk_charter) { create(:boat, available_for_bunk_charter: true) }
      let!(:second_trip) { create(:trip, name: "Z-Törn", boat: boat_for_bunk_charter) }
      let!(:first_trip) { create(:trip, name: "A-Törn", boat: boat_for_bunk_charter) }

      subject { boat_for_bunk_charter }
      
      it "should have the right trips in the right order" do
        boat_for_bunk_charter.trips.should == [first_trip, second_trip]
      end

      it "should destroy associated trips" do
        trips = boat_for_bunk_charter.trips
        boat_for_bunk_charter.destroy
        trips.each do |trip|
          lambda do
            Trip.find(trip.id)
          end.should raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
