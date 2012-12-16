require 'spec_helper'
require 'support/inquiry_base'

describe BoatInquiry do  
  let(:boat) { create(:boat) }
  let(:inquiry) { create(:boat_inquiry, boat: boat) }

  subject { inquiry }

  it_should_behave_like Inquiry

  it { should respond_to(:boat) }
  it { should respond_to(:begin_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:adults) }
  it { should respond_to(:children) }
  its(:boat) { should == boat }

  it { should be_valid }

  [:boat_id, :begin_date, :end_date, :adults, :children].each do |a|
    describe "when #{a.to_s} is not present" do
      before { inquiry[a] = nil }
      it { should_not be_valid }
    end
  end

  describe "dates" do
    [:begin_date, :end_date].each do |d|
      describe "when #{d.to_s}" do
        describe "is not a datetime" do
          before { inquiry.send("#{d.to_s}=".to_sym, "10bla") }
          it { should_not be_valid }
        end
        describe "is not a valid datetime" do
          before { inquiry.send("#{d.to_s}=".to_sym, "31.02.2012") }
          it { should_not be_valid }
        end
      end
    end
    
    describe "when end is before beginning" do
      before do
        inquiry.begin_date = 2.day.from_now
        inquiry.end_date = 1.day.from_now
      end
      it { should_not be_valid }
    end
  end

  describe "adults" do    
    describe "is not a number" do
      before { inquiry.adults = "a" }
      it { should_not be_valid }
    end

    describe "is not an integer" do
      before { inquiry.adults = 2.5 }
      it { should_not be_valid }
    end

    describe "is not positive" do
      before { inquiry.adults = 0 }
      it { should_not be_valid}
    end
  end

  describe "children" do
    describe "is not a number" do
      before { inquiry.children = "a" }
      it { should_not be_valid }
    end

    describe "is not an integer" do
      before { inquiry.children = 2.5 }
      it { should_not be_valid }
    end

    describe "is not non-negative" do
      before { inquiry.children = -1 }
      it { should_not be_valid}
    end
  end

  describe "method time_period_name" do
    before do
      inquiry.begin_date = Date.new(2013, 07, 13)
      inquiry.end_date = Date.new(2013, 07, 19)
    end
    it "should include begin_date and end_date" do
      inquiry.time_period_name.should == "13.07.2013 - 19.07.2013"
    end
  end

  describe "method people" do
    before do
      inquiry.adults = 2
      inquiry.children = 1
    end
    it "should return sum of adults and children" do
      inquiry.people.should == 3
    end
  end
end
