require 'spec_helper'

describe Setting do
  let(:setting) { build(:setting) }

  subject { setting }

  it { should respond_to(:key) }
  it { should respond_to(:value) }

  it { should be_valid }

  [:key, :value].each do |s|
    describe "#{s.to_s}" do
      describe "when #{s.to_s} is empty" do
        before { setting[s] = nil }
        it { should_not be_valid }
      end
    end
  end
end
