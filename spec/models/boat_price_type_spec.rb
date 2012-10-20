require 'spec_helper'

describe BoatPriceType do
  
  let(:type) { build(:boat_price_type) }

  subject { type }

  it { should respond_to(:name) }
  it { should respond_to(:duration) }
  
  it { should be_valid }

  describe "when name" do
    describe "is not present" do
      before { type.name = "" }
      it { should_not be_valid }
    end
    describe "contains HTML" do
      before { type.name = "<p>Hallo</p>" }
      it "should be sanitized on save" do
        type.save
        type.name.should == "Hallo"
      end
    end
    describe "has already been taken" do
      before { create(:boat_price_type, name: type.name) }
      it { should_not be_valid }
    end
  end

  describe "when duration" do
    describe "is not present" do
      before { type.duration = "" }
      it { should_not be_valid }
    end
    describe "is not a number" do
      before { type.duration = "ab" }
      it { should_not be_valid }
    end
    describe "is not positive" do
      before { type.duration = "-3" }
      it { should_not be_valid }
    end
    describe "is not an integer" do
      before { type.duration = 2.3 }
      it { should_not be_valid }
    end
  end  
end
