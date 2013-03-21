require 'spec_helper'

describe CompositeTrip do
  let(:boat) { create(:boat) }
  let(:ctrip) { build(:composite_trip, boat: boat) }

  subject { ctrip }

  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:description) }
  it { should respond_to(:boat) }
  it { should respond_to(:active) }

  it { should be_valid }

  it_should_behave_like "activatable", CompositeTrip

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
end
