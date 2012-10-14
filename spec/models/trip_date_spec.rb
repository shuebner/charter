require 'spec_helper'

describe TripDate do
  let(:trip) { create(:trip) }
  let(:date) { build(:trip_date, trip: trip) }

  subject { date }

  it { should respond_to(:begin) }
  it { should respond_to(:end) }
  its(:trip) { should == trip }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to trip_id" do
      expect do
        TripDate.new(trip_id: 2)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when begin is not present" do
    before { date.begin = nil }
    it { should_not be_valid }
  end

  describe "when end is not present" do
    before { date.end = nil }
    it { should_not be_valid }
  end

  describe "when end is before beginning" do
    before do
      date.begin = 2.day.from_now
      date.end = 1.day.from_now
    end
    it { should_not be_valid }
  end

  describe "when there is an overlapping trip_date for the same boat" do
    let(:other_trip) { create(:trip, boat: trip.boat) }
    let!(:overlapping_trip_date) { create(:trip_date, trip: other_trip, 
        begin: date.begin - 1.day, end: date.begin + 1.day) }
    it { should_not be_valid }
  end
end
