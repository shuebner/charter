require 'spec_helper'

describe BoatType do
  let(:type) { FactoryGirl.create(:boat_type) }
  subject { type }

  it { should respond_to(:manufacturer) }
  it { should respond_to(:model) }
  it { should respond_to(:length_hull) }
  it { should respond_to(:length_waterline) }
  it { should respond_to(:beam) }
  it { should respond_to(:draft) }
  it { should respond_to(:air_draft) }
  it { should respond_to(:displacement) }
  it { should respond_to(:sail_area_jib) }
  it { should respond_to(:sail_area_genoa) }
  it { should respond_to(:sail_area_main_sail) }
  it { should respond_to(:tank_volume_diesel) }
  it { should respond_to(:tank_volume_fresh_water) }
  it { should respond_to(:tank_volume_waste_water) }
  it { should respond_to(:permanent_bunks) }
  it { should respond_to(:convertible_bunks) }
  it { should respond_to(:max_no_of_people) }
  it { should respond_to(:recommended_no_of_people) }
  it { should respond_to(:headroom_saloon) }
  it { should respond_to(:boats) }

  it { should be_valid }

  describe "when manufacturer is not present" do
    before { type.manufacturer = nil }
    it { should_not be_valid }
  end

  describe "when model is not present" do
    before { type.model = nil }
    it { should_not be_valid }
  end

  describe "when trying to create type with same manufacturer and model" do
    let(:same_type) { FactoryGirl.build(:boat_type) }
    before do
      same_type.manufacturer = type.manufacturer
      same_type.model = type.model
    end
    subject { same_type }
    it { should_not be_valid }
  end

  describe "boat associations" do
    let!(:boat) { FactoryGirl.create(:boat, boat_type: type) }

    it "should have the right boats" do
      type.boats.should == [boat]
    end

    it "should destroy associated boats" do
      boats = type.boats
      type.destroy
      boats.each do |boat|
        lambda do
          Boat.find(boat.id)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
