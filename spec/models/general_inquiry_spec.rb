require 'spec_helper'
require 'support/inquiry_base'

describe GeneralInquiry do
  let(:inquiry) { create(:general_inquiry) }

  subject { inquiry }

  it_should_behave_like Inquiry
end
