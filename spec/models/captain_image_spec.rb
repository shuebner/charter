require 'spec_helper'

describe CaptainImage do
  let(:captain) { create(:captain) }
  let(:image) { build(:captain_image, attachable: captain) }

  subject { image }

  its(:attachable) { should == captain }

  it { should be_valid }
end
