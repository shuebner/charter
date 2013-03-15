require 'spec_helper'

describe PartnerImage do
  let(:partner) { create(:partner) }
  let(:image) { build(:partner_image, attachable: partner) }

  subject { image }

  it_should_behave_like Image

  its(:attachable) { should == partner }

  it { should be_valid }

  describe "when there is already a partner image" do
    before { create(:partner_image, attachable: partner) }
    it { should_not be_valid }
  end
end