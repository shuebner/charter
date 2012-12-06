require 'spec_helper'

describe TripBooking do
  let(:customer) { create(:customer) }
  let(:date) { create(:trip_date) }
  let(:booking) { build(:trip_booking, customer: customer, trip_date: date) }

  subject { booking }

  it { should respond_to(:number) }
  it { should respond_to(:no_of_bunks) }
  it { should respond_to(:cancelled_at) }
  it { should respond_to(:trip_date) }
  it { should respond_to(:customer) }
  it { should respond_to(:trip) }
  it { should respond_to(:cancelled?) }

  its(:customer) { should == customer }
  its(:customer_number) { should == customer.number }
  its(:trip_date) { should == date }
  its(:trip) { should == date.trip }

  describe "accessible attributes" do
    it "should not allow access to number" do
      expect do
        TripBooking.new(number: "T-2012-223")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
=begin    it "should not allow access to date_id" do
      expect do
        TripBooking.new(trip_date_id: date.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
=end    end
    it "should not allow access to deleted_at" do
      expect do
        TripBooking.new(updated_at: Time.now)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when number of bunks" do
    describe "is not present" do
      before { booking.no_of_bunks = nil }
      it { should_not be_valid }
    end

    describe "is not a number" do
      before { booking.no_of_bunks = "a" }
      it { should_not be_valid }
    end

    describe "is not positive" do
      before { booking.no_of_bunks = 0 }
      it { should_not be_valid}
    end

    describe "is more than the number of bunks still available for the date" do
      before do
        other_booking = create(:trip_booking, trip_date: date, no_of_bunks: 1)
        booking.no_of_bunks = date.trip.no_of_bunks
      end
      it { should_not be_valid }
    end
  end

  describe "if customer number is not present" do
    before { booking.customer = nil }
    it { should_not be_valid }
  end

  describe "when created through a customer" do
    let(:booking_through_customer) do
      customer.trip_bookings.create(trip_date_id: date.id, no_of_bunks: 1)
    end
    it "should have the right customer number" do
      booking_through_customer.customer_number.should == customer.number
    end
  end

  describe "when number" do
    describe "is already taken" do
      let!(:booking_with_same_number) { create(:trip_booking, number: booking.number) }
      it { should_not be_valid }
    end
  end


  describe "slug should be the parameterized number" do
    before { booking.save }
    its(:slug) { should == booking.number.parameterize }
  end

  describe "scope effective" do
    let!(:effective_booking) { create(:trip_booking) }
    let!(:cancelled_booking) { create(:trip_booking, cancelled_at: Time.now) }
    it "should show effective bookings" do
      TripBooking.effective.should include(effective_booking)
    end
    it "should not show cancelled bookings" do
      TripBooking.effective.should_not include(cancelled_booking)
    end
  end

  describe "cancel!" do
    it "on existing trip bookings should not change the number on save" do
      expect do
        booking.save
        booking.cancel!
        booking.save
      end.not_to change(booking, :number)
    end
    describe "if trip booking is still valid should set the right cancellation time" do
      before { booking.cancel! }
      its(:cancelled_at) { should >= Time.now - 1.second }
    end
    describe "if trip booking was already cancelled" do
      before { booking.cancel! }
      it "should not change the cancellation time" do
        expect { booking.cancel! }.not_to change(booking, :cancelled_at)
      end
    end
  end

  describe "cancelled?" do
    it "should return false if the trip booking has not been cancelled" do
      booking.cancelled?.should == false
    end
    it "should return true if the trip booking has been cancelled" do
      booking.cancel!
      booking.cancelled?.should == true
    end
  end

  describe "destruction of trip bookings" do
    before { booking.save }
    it "should not be possible" do
      expect { booking.destroy }.not_to change(TripBooking, :count)
    end
  end
end