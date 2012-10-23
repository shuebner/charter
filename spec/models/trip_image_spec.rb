require 'spec_helper'

describe TripImage do
  let(:trip) { create(:trip) }
  let(:image) { build(:trip_image, attachable: trip) }

  subject { image }

  its(:attachable) { should == trip }

  it { should be_valid }
end
