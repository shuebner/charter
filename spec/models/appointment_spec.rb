require 'spec_helper'

describe Appointment do
  let(:appointment) { build(:appointment) }

  subject { appointment }

  it { should respond_to :start_at }
  it { should respond_to :end_at }
  it { should respond_to :type }

  it { should be_valid }

  describe "dates" do
    [:start_at, :end_at].each do |d|
      describe "when #{d.to_s}" do
        
        describe "is not present" do
          before { appointment.send("#{d.to_s}=".to_sym, nil) }
          it { should_not be_valid}
        end
        
        describe "is not a datetime" do
          before { appointment.send("#{d.to_s}=".to_sym, "10bla") }
          it { should_not be_valid }
        end
        
        describe "is not a valid datetime" do
          before { appointment.send("#{d.to_s}=".to_sym, "31.02.2012 12:00") }
          it { should_not be_valid }
        end
      end
    end
    
    describe "when end is before beginning" do
      before do
        appointment.start_at = 2.day.from_now
        appointment.end_at = 1.day.from_now
      end
      it { should_not be_valid }
    end
  end
end
