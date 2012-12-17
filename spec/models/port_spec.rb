require 'spec_helper'

describe Port do
  let(:port) { build(:port) }

  subject { port }

  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:boats) }

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

  describe "association with boats" do
    before { port.save! }
    let(:boat1) { create(:boat, port: port) }
    let(:boat2) { create(:boat) }
    it "should have the right boats" do
      port.boats.should == [boat1]
    end

    describe "destruction" do
      describe "when there are boats at the port" do
        let!(:boat) { create(:boat, port: port) }
        it "should not be possible" do
          expect { port.destroy }.not_to change(Port, :count)
        end
      end
      describe "when there are no boats at the port" do
        it "should be possible" do
          expect { port.destroy }.to change(Port, :count).by(-1)
        end
      end
    end
  end
end