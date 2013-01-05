require 'spec_helper'

describe TripDate do
  let(:trip) { create(:trip) }
  let(:date) { build(:trip_date, trip: trip) }

  subject { date }

  it_should_behave_like Appointment

  it { should respond_to(:no_of_available_bunks) }
  it { should respond_to(:trip) }
  its(:trip) { should == trip }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to trip_id" do
      expect do
        TripDate.new(trip_id: 2)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when trip date overlaps" do
    describe "with other trip date for the same boat" do
      let(:other_trip) { create(:trip, boat: trip.boat) }
      let!(:overlapping_trip_date) { create(:trip_date, trip: other_trip, 
          start_at: date.start_at - 1.day, end_at: date.start_at + 1.day) }
      it { should_not be_valid }
    end
    describe "with boat booking for the same boat" do
      let!(:boat_booking) do
        create(:boat_booking, boat: date.trip.boat,
          start_at: date.start_at - 1.day, end_at: date.start_at + 1.day)        
      end
      it { should_not be_valid }
    end
  end

  describe "when trip dates are not overlapping but have the same day" do
    let(:other_trip) { create(:trip, boat: trip.boat) }
    let!(:not_overlapping_trip_date) { create(:trip_date, trip: other_trip, 
      start_at: date.end_at + 1.minute, end_at: date.end_at + 1.day) }
    it { should be_valid }
  end

  describe "association to trip bookings" do
    let!(:booking1) { create(:trip_booking, trip_date: date, no_of_bunks: 1) }
    let!(:booking2) { create(:trip_booking, trip_date: date, no_of_bunks: 1, cancelled_at: Time.now) }
    it "should have the right bookings in the right order" do
      date.trip_bookings.should == [booking2, booking1]
    end

    describe "deletion" do
      describe "without bookings" do
        let!(:date_without_bookings) { create(:trip_date) }
        it "should be allowed" do
          expect { date_without_bookings.destroy }.to change(TripDate, :count).by(-1)
        end
      end
      describe "with bookings" do
        before { date.save }
        it "should not be allowed" do
          expect { date.destroy }.not_to change(TripDate, :count)
        end
      end
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

  describe "display_name" do
    it  "should include date and time of beginning and end_at" do
      date.display_name.should == "#{I18n.l(date.start_at)} - #{I18n.l(date.end_at)}"
    end
  end

  describe "display_name_with_trip should include trip and display name" do
    its(:display_name_with_trip) { should == "#{date.trip.name} (#{date.display_name})" }
  end
end
