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
  its(:boat) { should == boat }
  its(:customer) { should == customer }

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
        begin_date: booking.start_at - 2.days, end_date: booking.end_at - 2.days) }
      it { should_not be_valid }
    end

    describe "with boat booking for the same boat" do
      let!(:other_booking) { create(:boat_booking, boat: booking.boat,
        start_at: booking.start_at - 2.days, end_at: booking.end_at - 2.days) }
      it { should_not be_valid }
    end    
  end
end
