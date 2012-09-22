require 'spec_helper'

describe Boat do
  let(:type) { FactoryGirl.create(:boat_type) }
  let(:boat) { FactoryGirl.create(:boat, boat_type: type) }

  subject { boat }

  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:year_of_construction) }
  it { should respond_to(:year_of_refit) }
  it { should respond_to(:engine_manufacturer) }
  it { should respond_to(:engine_model) }
  it { should respond_to(:engine_design) }
  it { should respond_to(:engine_output) }
  it { should respond_to(:battery_capacity) }
  it { should respond_to(:available_for_boat_charter) }
  it { should respond_to(:available_for_bunk_charter) }
  it { should respond_to(:deposit) }
  it { should respond_to(:cleaning_charge) }
  it { should respond_to(:fuel_charge) }
  it { should respond_to(:gas_charge) }
  it { should respond_to(:boat_type_id) }
  it { should respond_to(:boat_type) }

  its(:boat_type) { should == type }

  describe "accessible attributes" do
    it "should not allow access to boat_type_id" do
      expect do
        Boat.new(boat_type_id: 1)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when name is empty" do
    before { boat.name = nil }
    it { should_not be_valid }
  end

  describe "when slug is empty" do
    let!(:boat_without_slug) do 
      FactoryGirl.build(:boat, boat_type: type, name: "Testschiff Bla 2", slug: nil)
    end

    subject { boat_without_slug }

    describe "upon saving the slug should be automatically added" do
      before { boat_without_slug.save! }
      it { should be_valid }
      its(:slug) { should == "testschiff-bla-2" }    
    end
  end

  describe "when year_of_construction is empty" do
    before { boat.year_of_construction = nil }
    it { should_not be_valid }
  end

  describe "when available_for_boat_charter is empty" do
    before { boat.available_for_boat_charter = nil }
    it { should_not be_valid }
  end

  describe "when available_for_bunk_charter is empty" do
    before { boat.available_for_bunk_charter = nil}
    it { should_not be_valid }
  end
end
