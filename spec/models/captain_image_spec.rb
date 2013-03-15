require 'spec_helper'

describe CaptainImage do
  let(:captain) { create(:captain) }
  let(:image) { build(:captain_image, attachable: captain) }

  subject { image }

  it_should_behave_like Image

  its(:attachable) { should == captain }

  it { should be_valid }
end
