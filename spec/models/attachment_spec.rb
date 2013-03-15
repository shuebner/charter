require 'spec_helper'

describe Attachment do
  let(:attachment) { build(:attachment) }

  subject { attachment }

  it_should_behave_like Attachment   
end
