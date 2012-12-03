# encoding: utf-8
require 'spec_helper'
require 'support/inquiries_request'

describe "Inquiries" do
  
  subject { page }

  describe "general inquiry" do
    before { visit new_inquiry_path }

    include_examples "inquiries request", Inquiry, :general_inquiry
  end
end