require 'spec_helper'

describe BoatOwner do
  let(:owner) { build(:boat_owner) }

  subject { owner }

  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:is_self) }

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
end
