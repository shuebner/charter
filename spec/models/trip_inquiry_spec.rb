# encoding: utf-8
require 'spec_helper'
require 'support/inquiry_base'

describe TripInquiry do
  let(:trip_date) { create(:trip_date) }
  let(:inquiry) { build(:trip_inquiry, trip_date: trip_date) }

  subject { inquiry }

  it_should_behave_like Inquiry

  it { should respond_to(:trip_date) }
  it { should respond_to(:bunks) }
  its(:trip_date) { should == trip_date }

  it { should be_valid }

  describe "when trip_date is not present" do
    before { inquiry.trip_date = nil }
    it { should_not be_valid }
  end

  describe "when bunks" do
    describe "is not present" do
      before { inquiry.bunks = nil }
      it { should_not be_valid }
    end

    describe "is not a number" do
      before { inquiry.bunks = "a" }
      it { should_not be_valid }
    end

    describe "is not an integer" do
      before { inquiry.bunks = 2.5 }
      it { should_not be_valid }
    end

    describe "is not positive" do
      before { inquiry.bunks = 0 }
      it { should_not be_valid }
    end

    describe "is not less than the maximum number of bunks still available for the date" do      
      before do
        trip_date.trip.no_of_bunks = 4
        trip_date.trip_bookings.create(no_of_bunks: 1)
        inquiry.bunks = 4
      end
      it { should_not be_valid }
    end
  end
end
