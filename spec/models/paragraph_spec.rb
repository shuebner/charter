# encoding: utf-8
require 'spec_helper'

describe Paragraph do
  
  let(:page) { FactoryGirl.create(:static_page) }    
  let(:paragraph) { FactoryGirl.create(:paragraph, static_page: page) }

  subject { paragraph }

  it { should respond_to(:heading) }
  it { should respond_to(:text) }
  it { should respond_to(:order) }
  it { should respond_to(:static_page_id) }
  
  it { should respond_to(:static_page) }
  its(:static_page) { should == page }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to static_page_id" do
      expect do
        Paragraph.new(static_page_id: page.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when static_page_id is not present" do
    before { paragraph.static_page_id = nil }
    it { should_not be_valid }
  end

  describe "when order is not present" do
    before { paragraph.order = nil }
    it { should_not be_valid }
  end

  describe "when heading" do
    describe "is too long" do
      before { paragraph.heading = 'a' * 256 }
      it { should_not be_valid }
    end

    describe "starts with blank" do
      before { paragraph.heading = " "}
      it { should_not be_valid }
    end
  end
end
# == Schema Information
#
# Table name: paragraphs
#
#  id             :integer(4)      not null, primary key
#  heading        :string(255)
#  text           :text
#  order          :integer(4)      not null
#  static_page_id :integer(4)      not null
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

