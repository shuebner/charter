# encoding: utf-8
require 'spec_helper'
require 'support/inquiry_base'

describe Inquiry do
  let(:inquiry) { build(:inquiry) }

  subject { inquiry }

  it_behaves_like Inquiry
end
