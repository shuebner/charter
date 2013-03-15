require 'spec_helper'

describe BoatImage do
  let(:boat) { create(:boat) }
  let(:image) { build(:boat_image, attachable: boat) }

  subject { image }

  it_should_behave_like Image

  its(:attachable) { should == boat }

  it { should be_valid }
end
