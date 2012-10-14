# encoding: utf-8
require 'spec_helper'

describe Paragraph do
  
  let(:page) { create(:static_page) }    
  let(:paragraph) { build(:paragraph, static_page: page) }

  subject { paragraph }

  it { should respond_to(:heading) }
  it { should respond_to(:text) }
  it { should respond_to(:order) }
  it { should respond_to(:static_page_id) }
  it { should respond_to(:picture_uid) }
  it { should respond_to(:picture_name) }
  
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

  describe "when order" do
    describe "is not present" do
      before { paragraph.order = nil }
      it { should_not be_valid }
    end

    describe "is not a number" do
      before { paragraph.order = "a" }
      it { should_not be_valid }
    end

    describe "is not an integer" do
      before { paragraph.order = 2.5 }
      it { should_not be_valid }
    end

    describe "is not positive" do
      before { paragraph.order = -1 }
      it { should_not be_valid }
    end

    describe "is not unique" do
      before do
        paragraph_with_same_order = paragraph.dup
        paragraph_with_same_order.save
      end
      it { should_not be_valid }
    end

    describe "is not unique for multiple static pages" do
      before do
        page2 = create(:static_page, slug: 'slug2')
        paragraph_with_same_order = page2.paragraphs.create(heading: '2', 
          text: 'Abschnitt 2', order: paragraph.order)
        paragraph_with_same_order.save
      end
      it { should be_valid }
    end
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

  describe "when text contains HTML" do
    before { paragraph.text = "<h1>h1</h1><h2>h2</h2><p>p</p>" }
    it { should_not be_valid }
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

