require 'spec_helper'

describe TripDate do
  let(:trip) { create(:trip) }
  let(:date) { build(:trip_date, trip: trip) }

  subject { date }

  it_should_behave_like Appointment

  it { should respond_to(:no_of_available_bunks) }
  it { should respond_to(:trip) }
  it { should respond_to(:deferred) }
  it { should respond_to(:color) }
  its(:trip) { should == trip }
  its(:color) { should == trip.boat.color }

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
      
      describe "and is not deferred" do
        it { should_not be_valid }
      end

      describe "and is deferred" do
        before { date.defer! }
        it { should be_valid }
      end
    end

    describe "with boat booking for the same boat" do
      let!(:boat_booking) do
        create(:boat_booking, boat: date.trip.boat,
          start_at: date.start_at - 1.day, end_at: date.start_at + 1.day)        
      end

      describe "and is not deferred" do
        it { should_not be_valid }
      end

      describe "and is deferred" do
        before { date.defer! }
        it { should be_valid }
      end
    end
  end

  describe "when trip dates are not overlapping but have the same day" do
    let(:other_trip) { create(:trip, boat: trip.boat) }
    let!(:not_overlapping_trip_date) { create(:trip_date, trip: other_trip, 
      start_at: date.end_at + 1.minute, end_at: date.end_at + 1.day) }
    it { should be_valid }
  end

  describe "association to trip" do
    describe "which is part of a composite trip" do
      let(:ctrip) { create(:composite_trip) }
      before do
        trip.composite_trip = ctrip
      end
      describe "when a trip date already exists" do
        let!(:existing_trip_date) { create(:trip_date, trip: trip) }
        it { should_not be_valid }

        describe "but is not effective" do
          before do
            existing_trip_date.defer!
            existing_trip_date.save!
          end
          it { should be_valid }
        end
      end
    end
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

  describe "deferring mechanism" do
    before { date.deferred = false }
    
    describe "when deferred is not present" do
      before { date.deferred = nil }
      it { should_not be_valid }
    end

    describe "newly built trip date" do
      let!(:new_date) { TripDate.new }
      it "should not be deferred by default" do
        new_date.deferred.should == false
      end
    end
    
    describe "after defer! is called" do
      before { date.defer! }
      it "should be deferred" do
        date.deferred?.should == true
      end
    end
    
    describe "when undefer! is called after defer!" do
      before do
        date.defer!
        date.undefer!
      end
      it "should not be deferred" do
        date.deferred?.should == false
      end
    end

    describe "when among related trip bookings" do
      let!(:booking) { create(:trip_booking, trip_date: date) }

      describe "there exists an effective one" do
        it "date should not be deferrable" do
          date.defer!
          date.should_not be_valid
        end
      end

      describe "all are cancelled" do
        before do
          booking.cancel!
          booking.save!
        end
        it "date should be deferrable" do
          date.defer!
          date.should be_valid
        end
      end
    end

    describe "when boat bookings exist which overlap with a deferred trip date" do
      before { date.defer! }
      let!(:booking) { create(:boat_booking, boat: date.trip.boat,
        start_at: date.start_at - 1.day, end_at: date.start_at + 1.day) }

      it { should be_valid }

      it "should not be undeferrable" do
        date.undefer!
        date.should_not be_valid
      end
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

  describe "scope" do
    describe ".booked" do
      let(:booked_trip_date) { create(:trip_date) }
      let!(:trip_booking) { create(:trip_booking, trip_date: booked_trip_date) }
      let!(:unbooked_trip_date) { create(:trip_date) }
      it "should only contain trip dates for which at least one booking exists" do
        TripDate.booked.should == [booked_trip_date]
      end
    end

    describe ".effective" do
      let(:deferred_trip_date) { create(:trip_date) }
      before do
        date.save!
        deferred_trip_date.defer!
        deferred_trip_date.save!
      end
      it "should include non-deferred trip dates" do
        TripDate.effective.should include(date)
      end
      it "should not include deferred trip dates" do
        TripDate.effective.should_not include(deferred_trip_date)
      end
    end
  end

  describe "method overlapping" do
    before { date.save! }

    let(:non_overlapping_trip_date) { build(:trip_date, trip: date.trip,
      start_at: date.end_at + 1.day, end_at: date.end_at + 3.days) }
    let(:overlapping_trip_date) { build(:trip_date, trip: date.trip,
      start_at: date.end_at - 1.day, end_at: date.end_at + 1.day) }

    it "should return effective overlapping trip dates" do
      TripDate.overlapping(overlapping_trip_date).should include(date)
    end
    it "should not return deferred overlapping trip dates" do
      date.defer!
      date.save!        
      TripDate.overlapping(overlapping_trip_date).should_not include(date)
    end
    it "should not return non-overlapping trip dates" do
      TripDate.overlapping(non_overlapping_trip_date).should_not include(date)
    end
    it "should not return the argument itself" do
      non_overlapping_trip_date.save!
      TripDate.overlapping(non_overlapping_trip_date).should_not include(non_overlapping_trip_date)
    end
  end
end
