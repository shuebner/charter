require 'spec_helper'

describe CompositeTrip do
  let(:boat) { create(:boat) }
  let(:ctrip) { create(:composite_trip, boat: boat) }
  let(:trip) { create(:trip_for_composite_trip, composite_trip: ctrip) }

  subject { ctrip }

  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:description) }
  it { should respond_to(:active) }

  it { should respond_to(:boat) }
  it { should respond_to(:trips) }

  it { should be_valid }

  it_should_behave_like "activatable", CompositeTrip

  it_should_behave_like "imageable", :composite_trip, :composite_trip_image

  describe "when boat is not present" do
    before { ctrip.boat = nil }
    it { should_not be_valid }
  end

  describe "when name" do
    describe "is not present" do
      before { ctrip.name = "" }
      it { should_not be_valid }
    end

    describe "contains HTML" do
      before { ctrip.name = "<b>Name</b>" }
      it "should be sanitized on save" do
        ctrip.save!
        ctrip.name.should == "Name"
      end
    end
  end

  describe "when description" do
    describe "is not present" do
      before { ctrip.description = "" }
      it { should_not be_valid }
    end

    describe "contains HTML" do
      before { ctrip.description = "<p>Hallo</p>" }
      it "should be sanitized on save" do
        ctrip.save!
        ctrip.description.should == "Hallo"
      end
    end
  end

  describe "when active" do
    describe "is not present" do
      before { ctrip.active = nil }
      it { should_not be_valid }
    end
  end

  describe "association with boat" do
    its(:boat) { should == boat }
  end

  describe "association with trips" do
    its(:trips) { should == [trip] }

    it "should destroy associated trips" do
      trip.save!
      expect { ctrip.destroy }.to change(Trip, :count).by(-1)
    end
  end
end
