# encoding: utf-8
require 'spec_helper'

describe Trip do
  let(:boat) { create(:boat) }
  let(:trip) { create(:trip, boat: boat) }

  subject { trip }

  it { should respond_to(:boat_id) }
  it { should respond_to(:boat) }
  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:description) }
  it { should respond_to(:no_of_bunks) }
  it { should respond_to(:price) }

  its(:boat) { should == boat }

  it { should be_valid }
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

  describe "when name is not present" do
    before { trip.name = "" }
    it { should_not be_valid }
  end

  describe "when description" do
    describe "is not present" do
      before { trip.description = "" }
      it { should_not be_valid }
    end

    describe "contains HTML" do
      before { trip.description = "<p><h2>" }
      it { should_not be_valid }
    end
  end

  describe "when number of bunks is not present" do
    before { trip.no_of_bunks = nil }
    it { should_not be_valid }
  end

  describe "when price is not present" do
    before { trip.price = nil }
    it { should_not be_valid }
  end

  describe "default sort order" do
    let!(:second_trip) { create(:trip, name: "Z-Törn") }
    let!(:first_trip) { create(:trip, name: "A-Törn") }
    it "should be ascending by name" do
      Trip.all.should == [first_trip, second_trip]
    end
  end

  describe "TripDate association" do
    let!(:date2) { create(:trip_date, trip: trip, begin: 4.day.from_now, end: 7.day.from_now) }
    let!(:date1) { create(:trip_date, trip: trip, begin: 1.day.from_now, end: 3.day.from_now) }
    it "should have the right dates in the right order" do
      trip.trip_dates.should == [date1, date2]
    end
    it "should destroy associated dates" do
      dates = trip.trip_dates
      trip.destroy
      dates.each do |date|
        lambda do
          TripDate.find(date.id)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
