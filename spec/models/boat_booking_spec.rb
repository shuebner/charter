require 'spec_helper'

describe BoatBooking do

  let(:customer) { create(:customer) }
  let(:boat) { create(:boat) }
  let(:booking) { build(:boat_booking, customer: customer, boat: boat) }

  subject { booking }

  it_should_behave_like Appointment

  it { should respond_to(:number) }
  it { should respond_to(:slug) }
  it { should respond_to(:adults) }
  it { should respond_to(:children) }
  it { should respond_to(:cancelled) }
  it { should respond_to(:color) }
  its(:boat) { should == boat }
  its(:customer) { should == customer }
  its(:color) { should == booking.boat.color }

  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to number" do
      expect do
        BoatBooking.new(number: "B-2012-223")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to slug" do
      expect do
        BoatBooking.new(slug: "blabla")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  [:boat, :customer, :adults, :children].each do |a|
    describe "when #{a.to_s} is not present" do
      before { booking.send("#{a.to_s}=".to_sym, nil) }
      it { should_not be_valid }
    end
  end

  describe "adults" do    
    describe "is not a number" do
      before { booking.adults = "a" }
      it { should_not be_valid }
    end

    describe "is not an integer" do
      before { booking.adults = 2.5 }
      it { should_not be_valid }
    end

    describe "is not positive" do
      before { booking.adults = 0 }
      it { should_not be_valid}
    end
  end

  describe "children" do
    describe "is not a number" do
      before { booking.children = "a" }
      it { should_not be_valid }
    end

    describe "is not an integer" do
      before { booking.children = 2.5 }
      it { should_not be_valid }
    end

    describe "is not non-negative" do
      before { booking.children = -1 }
      it { should_not be_valid}
    end
  end

  describe "when adults + children is greater than the maximum number of people on the boat" do
    before do
      boat.max_no_of_people = 4
      booking.adults = 4
      booking.children = 1
    end
    it { should_not be_valid }
  end

  describe "number" do
    before { booking.save! }
    it "should be generated on save" do
      booking.number.should_not be_blank
    end
  end

  describe "when number" do
    describe "is already taken" do
      let!(:booking_with_same_number) { create(:boat_booking, number: booking.number) }
      it { should_not be_valid }
    end
  end

  describe "method people" do
    before do
      booking.adults = 2
      booking.children = 1
    end
    it "should return adults + children" do
      booking.people.should == 3
    end
  end

  describe "cancellation" do
    describe "cancel!" do
      it "on existing boat bookings should not change the number on save" do
        expect do
          booking.save
          booking.cancel!
          booking.save
        end.not_to change(booking, :number)
      end
    end

    describe "cancelled?" do
      it "should return false if the boat booking has not been cancelled" do
        booking.cancelled?.should == false
      end
      it "should return true if the trip bookings has been cancelled" do
        booking.cancel!
        booking.cancelled?.should == true
      end    
    end

    describe "cancelled bookings" do
      before do
        booking.cancel!
        booking.save!
      end
      it "should not be changeable" do
        expect do
          booking.start_at = booking.end_at - 1.day
          booking.save!
        end.to raise_error(ActiveRecord::ReadOnlyRecord)
      end
    end
  end

  describe "display name" do
    it "should include customer name and begin and end dates" do
      booking.display_name.should == "#{booking.customer.display_name} ("\
        "#{I18n.l(booking.start_at)} - #{I18n.l(booking.end_at)})"
    end
  end

  describe "when boat booking overlaps" do
    describe "with trip date for the same boat" do
      let(:trip) { create(:trip, boat: booking.boat) }
      let!(:trip_date) { create(:trip_date, trip: trip,
        start_at: booking.start_at - 2.days, end_at: booking.end_at - 2.days) }
      
      describe "which is not deferred" do
        it { should_not be_valid }
      end

      describe "which is deferred" do
        before do
          trip_date.defer!
          trip_date.save!
        end
        it { should be_valid }
      end
    end

    describe "with boat booking for the same boat" do
      let!(:other_booking) { create(:boat_booking, boat: booking.boat,
        start_at: booking.start_at - 2.days, end_at: booking.end_at - 2.days) }
      
      describe "which is still effective" do
        it { should_not be_valid }
      end
    
      describe "which is cancelled" do
        before do 
          other_booking.cancel!
          other_booking.save!
        end
        it { should be_valid }
      end
    end
  end

  describe "scope" do
    describe ".effective" do
      let(:cancelled_booking) { create(:boat_booking) }
      before do
        cancelled_booking.cancel!
        cancelled_booking.save!
        booking.save!
      end

      it "should include non-cancelled boat bookings" do
        BoatBooking.effective.should include(booking)
      end
      it "should not include cancelled boat bookings" do
        BoatBooking.effective.should_not include(cancelled_booking)
      end
    end
    describe ".in_current_period" do
      let!(:current_period_start_at) { create(:setting, key: 'current_period_start_at', value: I18n.l(Date.new(2014, 1, 1))) }
      let!(:current_period_end_at) { create(:setting, key: 'current_period_end_at', value: I18n.l(Date.new(2014, 12, 31))) }      
      let(:booking_in_current_period) { create(:boat_booking, 
        start_at: Date.new(2014, 1, 2), end_at: Date.new(2014, 1, 20)) }
      let(:booking_not_in_current_period) { create(:boat_booking, 
        start_at: Date.new(2015, 1, 2), end_at: Date.new(2015, 1, 20)) }
      it "should contain boat bookings within the current period" do
        BoatBooking.in_current_period.should include(booking_in_current_period)
      end
      it "should not contain boat bookings outside of the current period" do
        BoatBooking.in_current_period.should_not include(booking_not_in_current_period)
      end
    end
  end

  describe "method overlapping" do    
    before { booking.save! }

    let(:non_overlapping_boat_booking) { build(:boat_booking, boat: booking.boat,
      start_at: booking.end_at + 1.day, end_at: booking.end_at + 3.days) }
    let(:overlapping_boat_booking) { build(:boat_booking, boat: booking.boat,
      start_at: booking.end_at - 1.day, end_at: booking.end_at + 1.day) }
    
    it "should return effective overlapping boat bookings" do
      BoatBooking.overlapping(overlapping_boat_booking).should include(booking)
    end
    it "should not return cancelled overlapping boat bookings" do
      booking.cancel!
      booking.save!
      BoatBooking.overlapping(overlapping_boat_booking).should_not include(booking)
    end 
    it "should not return non-overlapping boat bookings" do
      BoatBooking.overlapping(non_overlapping_boat_booking).should_not include(booking)
    end
    it "should not return the argument itself" do
      non_overlapping_boat_booking.save!
      BoatBooking.overlapping(non_overlapping_boat_booking).should_not include(non_overlapping_boat_booking)
    end
  end
end
