require 'spec_helper'

describe Image do
  let(:image) { build(:image) }

  subject { image }

  it_should_behave_like Image
end