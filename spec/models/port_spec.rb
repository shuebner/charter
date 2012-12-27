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
    let!(:boat2) { create(:boat, port: port, model: "Zora 26") }
    let!(:boat1) { create(:boat, port: port, model: "Adam 34") }
    it "should have the right boats in the right order" do
      port.boats.should == [boat1, boat2]
    end

    describe "destruction" do
      describe "when there are boats at the port" do
        it "should not be possible" do
          expect { port.destroy }.not_to change(Port, :count)
        end
      end
      describe "when there are no boats at the port" do
        before do
          boat1.destroy
          boat2.destroy
        end
        it "should be possible" do
          expect { port.destroy }.to change(Port, :count).by(-1)
        end
      end
    end
  end


  describe "scope" do
    describe "default" do
      before do
        port.name = "Xanten"
        port.save!
      end
      let!(:port2) { create(:port, name: "Aachen") }
      it "should yield ports in alphabetical order" do
        Port.all.should == [port2, port]
      end
    end

    describe "with_visible_boat" do
      # zwei Boote für Hafen erstellen, um Mehrfachnennung eines Hafens im Array auszuschließen
      let!(:boat1) { create(:boat, port: port) }
      let!(:boat2) { create(:boat, port: port) }
      let!(:port_without_visible_boat) { create(:port) }
      let!(:invisible_boat) { create(:unavailable_boat, port: port_without_visible_boat) }
      it "should only yield ports with at least one visible boat" do
        Port.with_visible_boat.should == [port]
      end
    end

    describe "distinction between own ports and other ports" do
      let!(:myself) { create(:boat_owner, is_self: true) }
      let!(:someone_else) { create(:boat_owner, is_self: false) }
      let!(:own_port) { create(:port) }
      let!(:other_port) { create(:port) }
      let!(:own_boat) { create(:boat, owner: myself, port: own_port) }
      let!(:other_boat) { create(:boat, owner: someone_else, port: other_port) }
      describe "own" do
        it "should only yield ports that have boats which belong to oneself" do
          Port.own.should == [own_port]
        end
      end
      describe "external" do
        it "should only yield port that have boats which belong to others" do
          Port.external.should == [other_port]
        end
      end
    end
  end
end