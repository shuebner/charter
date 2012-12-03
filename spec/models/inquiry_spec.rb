# encoding: utf-8
require 'spec_helper'
require 'support/inquiry_base'

describe Inquiry do
  let(:inquiry) { build(:inquiry) }

  subject { inquiry }

  it_behaves_like Inquiry

  describe "method full_name" do
    it "should return the full name" do
      inquiry.full_name.should == "#{inquiry.first_name} #{inquiry.last_name}"
    end
  end
end
