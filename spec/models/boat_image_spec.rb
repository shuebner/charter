require 'spec_helper'

describe BoatImage do
  let(:boat) { create(:boat) }
  let(:image) { build(:boat_image, attachable: boat) }

  subject { image }

  its(:attachable) { should == boat }

  it { should be_valid }
end
