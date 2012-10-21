require 'spec_helper'

describe BoatPrice do
  let(:season) { create(:season) }
  let(:boat) { create(:boat) }
  let(:type) { create(:boat_price_type) }
  let(:price) { build(:boat_price, season: season, boat: boat, 
    boat_price_type: type) }

  subject { price }

  it { should respond_to(:value) }
  its(:boat) { should == boat }
  its(:season) { should == season }
  its(:boat_price_type) { should == type }

  it { should be_valid }

  describe "when value" do
    describe "is not present" do
      before { price.value = "" }
      it { should_not be_valid }
    end
    describe "is not a number" do
      before { price.value = "ab" }
      it { should_not be_valid }
    end
    describe "is not positive or zero" do
      before { price.value = -3 }
      it { should_not be_valid }
    end
  end

  describe "when season is not present" do
    before { price.season = nil }
    it { should_not be_valid }
  end

  describe "when boat is not present" do
    before { price.boat = nil }
    it { should_not be_valid }
  end

  describe "when boat price type is not present" do
    before { price.boat_price_type = nil }
    it { should_not be_valid }
  end

  describe "when boat price type is already used for the same boat and season" do
    before do 
      create(:boat_price, season: price.season, boat: price.boat, 
        boat_price_type: price.boat_price_type)
    end
    it { should_not be_valid }
  end

  describe "equality between two boat price objects" do
    let!(:other_price) do 
      create(:boat_price, boat: price.boat, season: price.season, 
        boat_price_type: price.boat_price_type, value: price.value)
    end
    it "should be given if their associations and their value is equal" do
      price.should == other_price
    end
    it "should not be given if they differ in association or value" do
      [:boat_id, :season_id, :boat_price_type_id, :value].each do |a|
        old_value = other_price[a]
        other_price[a] += 1
        price.should_not == other_price
        other_price[a] = old_value
      end
    end
  end
end
