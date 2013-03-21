require 'spec_helper'

describe CompositeTripImage do
  let(:composite_trip) { create(:composite_trip) }
  let(:image) { build(:composite_trip_image, attachable: composite_trip) }

  subject { image }

  it_should_behave_like Image

  its(:attachable) { should == composite_trip }

  it { should be_valid }
end
