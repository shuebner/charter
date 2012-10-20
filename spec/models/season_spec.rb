require 'spec_helper'

describe Season do
  let!(:season) { build(:season) }

  subject { season }

  it { should respond_to(:name) }
  it { should respond_to(:begin_date) }
  it { should respond_to(:end_date) }

  describe "when name" do
    describe "is not present" do
      before { season.name = "" }
      it { should_not be_valid }
    end
    describe "contains HTML" do
      before { season.name = "<p>Hallo</p>" }
      it "should be sanitized on save" do
        season.save
        season.name.should == "Hallo"
      end
    end
  end

  describe "when begin date" do
    describe "is not present" do
      before { season.begin_date = "" }
      it { should_not be_valid }
    end
    describe "is not a date" do
      before { season.begin_date = "10bla" }
      it { should_not be_valid }
    end
    describe "is not a valid date" do
      before { season.begin_date = "31.02.2012" }
      it { should_not be_valid }
    end
  end

  describe "when end date" do
    describe "is not present" do
      before { season.end_date = "" }
      it { should_not be_valid }
    end
    describe "is not a date" do
      before { season.end_date = "10bla" }
      it { should_not be_valid }
    end
    describe "is not a valid date" do
      before { season.end_date = "31.02.2012" }
      it { should_not be_valid }
    end
  end

  describe "when end lies before beginning" do
    before { season.end_date = season.begin_date - 1.day }
    it { should_not be_valid }
  end

  describe "when seasons overlap" do
    before do
      create(:season, begin_date: season.begin_date - 1.day, 
        end_date: season.end_date + 1.day)
    end
    it { should_not be_valid }
  end
end
