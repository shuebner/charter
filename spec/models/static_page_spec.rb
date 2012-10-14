require 'spec_helper'

describe StaticPage do
  let(:page) { build(:static_page) }

  subject { page }

  it { should respond_to(:slug) }
  it { should respond_to(:title) }
  it { should respond_to(:heading) }
  it { should respond_to(:text) }
  it { should respond_to(:paragraphs) }
  it { should respond_to(:picture_uid) }
  it { should respond_to(:picture_name) }

  it { should be_valid }

  describe "when title" do
    describe "is nil" do
      before { page.title = nil }
      it { should_not be_valid }
    end

    describe "is blank" do
      before { page.title = " " }
      it { should_not be_valid }
    end

    describe "is too long" do
      before { page.title = 'a' * 101 }
      it { should_not be_valid }
    end
  end

  describe "when heading" do
    describe "when heading is nil" do
      before { page.heading = nil }
      it { should be_valid }
    end

    describe "is too long" do
      before { page.heading = 'a' * 101 }
      it { should_not be_valid}
    end
  end

  describe "when text" do
    describe "is nil" do
      before { page.text = nil }
      it { should be_valid }
    end

    describe "uses forbidden HTML tags" do
      before { page.text = '<h1>h</h1> blablabla' }
      it { should_not be_valid }
    end
  end

  describe "paragraph associations" do
    before { page.save }
    let!(:second_paragraph) { create(:paragraph, static_page: page, order: 1) }
    let!(:first_paragraph) { create(:paragraph, static_page: page, order: 0) }
    
    it "should have the right paragraphs in the right order" do
      page.paragraphs.should == [first_paragraph, second_paragraph]
    end

    it "should destroy associated paragraphs" do
      paragraphs = page.paragraphs
      page.destroy
      paragraphs.each do |paragraph|
        lambda do
          Paragraph.find(paragraph.id)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
# == Schema Information
#
# Table slug: static_pages
#
#  id         :integer(4)      not null, primary key
#  slug       :string(30)      not null
#  title      :string(100)     not null
#  heading    :string(100)
#  text       :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

