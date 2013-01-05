require 'spec_helper'

shared_examples_for Appointment do
  
  it { should respond_to :start_at }
  it { should respond_to :end_at }
  it { should respond_to :type }

  it { should be_valid }

  describe "dates" do
    [:start_at, :end_at].each do |d|
      describe "when #{d.to_s}" do
        
        describe "is not present" do
          before { subject.send("#{d.to_s}=".to_sym, nil) }
          it { should_not be_valid}
        end
        
        describe "is not a datetime" do
          before { subject.send("#{d.to_s}=".to_sym, "10bla") }
          it { should_not be_valid }
        end
        
        describe "is not a valid datetime" do
          before { subject.send("#{d.to_s}=".to_sym, "31.02.2012 12:00") }
          it { should_not be_valid }
        end
      end
    end
    
    describe "when end is before beginning" do
      before do
        subject.start_at = 2.day.from_now
        subject.end_at = 1.day.from_now
      end
      it { should_not be_valid }
    end
  end
end
