require 'spec_helper'

describe TripDate do
  let(:trip) { create(:trip) }
  let(:date) { create(:trip_date, trip: trip) }

  subject { date }

  it { should respond_to(:begin) }
  it { should respond_to(:end) }
  it { should respond_to(:no_of_available_bunks) }
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
    before do
      other_trip = create(:trip, boat: trip.boat)
      @overlapping_trip_date = build(:trip_date, trip: other_trip, 
        begin: date.begin - 1.day, end: date.begin + 1.day)
    end
    it "should not be valid" do
      @overlapping_trip_date.should_not be_valid
    end
  end

  describe "association to trip bookings" do
    let!(:booking1) { create(:trip_booking, trip_date: date, no_of_bunks: 1) }
    let!(:booking2) { create(:trip_booking, trip_date: date, no_of_bunks: 1, cancelled_at: Time.now) }
    let!(:booking3) { create(:trip_booking, trip_date: date, no_of_bunks: 1) }
    before { date.reload }
    it "should have the right bookings in the right order" do
      date.trip_bookings.should == [booking3, booking2, booking1]
    end
  end

  describe "number of available bunks" do
    let!(:effective_booking) do 
      create(:trip_booking, trip_date: date, no_of_bunks: 1)
    end
    let!(:ineffective_booking) do 
      create(:trip_booking, trip_date: date, no_of_bunks: 1, cancelled_at: Time.now)
    end
    it "should be the number of bunks that are not effectively booked" do
      date.no_of_available_bunks.should == trip.no_of_bunks - effective_booking.no_of_bunks
    end
  end
end
