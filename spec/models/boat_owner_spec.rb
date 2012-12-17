require 'spec_helper'

describe BoatOwner do
  let(:owner) { build(:boat_owner) }

  subject { owner }

  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:is_self) }

  it { should respond_to(:boats) }

  it { should be_valid }

  [:name, :is_self].each do |a|
    describe "when #{a.to_s} is not present" do
      before { owner[a] = nil }
      it { should_not be_valid }
    end
  end

  describe "when name has already been used" do
    before { create(:boat_owner, name: owner.name) }
    it { should_not be_valid }
  end

  describe "association to boat" do
    let!(:own_boat) { create(:boat, owner: owner) }
    let!(:other_boat) { create(:boat) }
    it "should include the right boats" do
      owner.boats.should == [own_boat]
    end

    describe "destruction" do
      before { owner.save! }
      describe "when owner has boats" do
        it "should not be allowed" do
          expect { owner.destroy }.not_to change(BoatOwner, :count)
        end
      end
      describe "when owner has no boats" do
        before { own_boat.destroy }
        it "should be allowed" do
          expect { owner.destroy }.to change(BoatOwner, :count).by(-1)
        end
      end
    end    
  end
end
