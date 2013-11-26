require 'spec_helper'

describe Setting do
  let(:setting) { build(:setting) }

  subject { setting }

  it { should respond_to(:key) }
  it { should respond_to(:value) }
  it { should respond_to(:current_period_start_at) }
  it { should respond_to(:current_period_end_at) }

  it { should be_valid }

  [:key, :value].each do |s|
    describe "when #{s.to_s}" do
      describe "is empty" do
        before { setting[s] = nil }
        it { should_not be_valid }
      end
    end
  end

  describe "date settings" do
    [:current_period_start_at, :current_period_end_at].each do |key|
      before { setting.key = key.to_s }
      describe "when #{key.to_s} it not a valid date" do        
        ["bla", "31.02.2013"].each do |invalid_date_string|
          before { setting.value = invalid_date_string }
          it { should_not be_valid }
        end
      end
    end
  end
end