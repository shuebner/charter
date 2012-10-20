require 'spec_helper'

describe Season do
  let!(:season) { build(:season) }

  subject { season }

  it { should respond_to(:name) }
  it { should respond_to(:begin_date) }
  it { should respond_to(:end_date) }
  
  it { should be_valid }

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

  describe "default sort order" do
    let!(:season1) { create(:season, begin_date: 4.days.from_now, end_date: 5.days.from_now) }
    let!(:season2) { create(:season, begin_date: 1.day.from_now, end_date: 2.days.from_now) }
    it "should be ascending by begin date" do
      Season.all.should == [season2, season1]
    end
  end

  describe "association to boat prices" do
    let!(:price) { create(:boat_price, season: season) }
    its(:boat_prices) { should == [price] }

    it "should delete associated boat prices" do
      expect { season.destroy }.to change(BoatPrice, :count).by(-1)
    end      
  end
end
