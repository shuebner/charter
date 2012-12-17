require 'spec_helper'

describe Port do
  let(:port) { build(:port) }

  subject { port }

  it { should respond_to(:name) }
  it { should respond_to(:slug) }

  it { should be_valid }

  describe "when name" do
    describe "is not present" do
      before { port.name = nil }
      it { should_not be_valid }
    end
    describe "is not unique" do
      before { create(:port, name: port.name) }
      it { should_not be_valid }
    end
  end
end