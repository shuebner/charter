# encoding: utf-8
require 'spec_helper'

describe Trip do
  let(:boat) { create(:boat) }
  let(:trip) { build(:trip, boat: boat) }

  subject { trip }

  it { should respond_to(:boat_id) }
  it { should respond_to(:boat) }
  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:description) }
  it { should respond_to(:no_of_bunks) }
  it { should respond_to(:price) }
  it { should respond_to(:composite_trip) }

  its(:boat) { should == boat }

  it { should be_valid }

  it_should_behave_like "activatable", Trip

  it_should_behave_like "imageable", :trip, :trip_image
=begin
  describe "accessible attributes" do
    it "should not allow access to boat_id" do
      expect do
        Trip.new(boat_id: 2)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
=end
  describe "when boat_id is not present" do
    before { trip.boat_id = nil }
    it { should_not be_valid }
  end

  describe "when name" do 
    describe "is not present" do
      before { trip.name = "" }
      it { should_not be_valid }
    end
    describe "contains HTML" do
      before { trip.name = "<b>Name</b>" }
      it "should be sanitized on save" do
        trip.save
        trip.name.should == "Name"
      end
    end
  end

  describe "when description" do
    describe "is not present" do
      before { trip.description = "" }
      it { should_not be_valid }
    end

    describe "contains HTML" do
      before { trip.description = "<p>Hallo</p>" }
      it "should be sanitized on save" do
        trip.save
        trip.description.should == "Hallo"
      end
    end
  end

  describe "when number of bunks" do
    describe "is not present" do
      before { trip.no_of_bunks = nil }
      it { should_not be_valid }
    end

    describe "is not a number" do
      before { trip.no_of_bunks = "a" }
      it { should_not be_valid }
    end

    describe "is not an integer" do
      before { trip.no_of_bunks = 2.5 }
      it { should_not be_valid }
    end

    describe "is not positive" do
      before { trip.no_of_bunks = 0 }
      it { should_not be_valid }
    end

    describe "is not less than the maximum number of people on the boat" do
      before do
        boat.permanent_bunks = 4
        boat.convertible_bunks = 2
        trip.no_of_bunks = 6
      end
      it { should_not be_valid }
    end
  end

  describe "when price" do
    describe "is not present" do
      before { trip.price = nil }
      it { should_not be_valid }
    end

    describe "is not a number" do
      before { trip.price = "a" }
      it { should_not be_valid }
    end

    describe "is not positive" do
      before { trip.price = -100 }
      it { should_not be_valid }
    end
  end

  describe "display name" do
    it "should be the name of the trip" do
      trip.display_name.should == trip.name
    end
  end

  describe "scope" do
    describe ".visible" do
      let!(:inactive_trip) { create(:trip, active: false) }
      let!(:active_trip) { create(:trip, active: true) }
      it "should include all active trips" do
        Trip.visible.should include(active_trip)
      end
      it "should not include any inactive trips" do
        Trip.visible.should_not include(inactive_trip)
      end
    end

    describe "single" do
      let!(:single_trip) { create(:trip) }
      let!(:trip_for_composite_trip) { create(:trip_for_composite_trip) }
      it "should include single trips" do
        Trip.single.should include(single_trip)
      end
      it "should not include trips which belong to a composite trip" do
        Trip.single.should_not include(trip_for_composite_trip)
      end
    end
  end

  describe "Boat association" do    
    it "should only be possible with boats available for bunk charter" do
      no_bunk_charter_boat = create(:boat_charter_only_boat)
      trip = build(:trip, boat: no_bunk_charter_boat)
      trip.should_not be_valid
    end

    describe "when part of a composite trip" do
      let(:ctrip) { create(:composite_trip) }
      before { trip.composite_trip = ctrip }        
      
      it "should set the boat to the same boat when setting the composite trip" do
        trip.boat.should == ctrip.boat
      end

      describe "when boat is different from the boat of the composite trip" do
        before { trip.boat_id = boat.id }
        it { should_not be_valid }
      end
    end
  end

  describe "association to composite trip" do
    let(:ctrip) { create(:composite_trip) }
    before { trip.composite_trip = ctrip }

    its(:composite_trip) { should == ctrip }

    describe "when trip has more than one trip date" do
      let!(:new_trip) { create(:trip) }
      let!(:date1) { create(:trip_date, trip: new_trip) }
      let!(:date2) { create(:trip_date, trip: new_trip) }
      subject { new_trip }
      before { new_trip.composite_trip = ctrip }
      
      it { should_not be_valid }
    end
  end

  describe "TripDate association" do
    let!(:date2) { create(:trip_date, trip: trip, 
      start_at: 4.day.from_now, end_at: 7.day.from_now) }
    let!(:date1) { create(:trip_date, trip: trip, 
      start_at: 1.day.from_now, end_at: 3.day.from_now) }
    it "should have the right dates" do
      trip.trip_dates.sort.should == [date1, date2].sort
    end
    describe "deletion" do
      describe "without trip dates" do
        let!(:trip_without_dates) { create(:trip) }
        it "should be allowed" do
          expect { trip_without_dates.destroy }.to change(Trip, :count).by(-1)
        end
      end
      describe "with trip dates" do
        before { trip.save }
        it "should not be allowed" do
          expect { trip.destroy }.not_to change(Trip, :count)
        end
      end
    end
  end
end
