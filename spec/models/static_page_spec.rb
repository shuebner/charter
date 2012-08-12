require 'spec_helper'

describe StaticPage do
  let(:page) { FactoryGirl.create(:static_page) }

  subject { page }

  it { should respond_to(:name) }
  it { should respond_to(:title) }
  it { should respond_to(:heading) }
  it { should respond_to(:text) }
  it { should respond_to(:paragraphs) }

  it { should be_valid }

  describe "when name" do
    describe "is not present" do
      before { page.name = " " }
      it { should_not be_valid }
    end

    describe "is too long" do
      before { page.name = 'a' * 31 }
      it { should_not be_valid}
    end

    describe "already exists" do
      before do 
        @static_page_with_same_title = page.dup
        @static_page_with_same_title.name = @static_page_with_same_title.name.upcase
        @static_page_with_same_title.save
      end
      it { should_not be_valid }
    end
  end

  describe "when title" do
    describe "is not present" do
      before { page.name = " " }
      it { should_not be_valid }
    end

    describe "is too long" do
      before { page.title = 'a' * 101 }
      it { should_not be_valid }
    end
  end

  describe "when heading" do
    describe "is to long" do
      before { page.heading = 'a' * 101 }
      it { should_not be_valid}
    end
  end

  describe "when text" do
    describe "uses forbidden HTML tags" do
      before { page.text = '<h1>h</h1> blablabla' }
      it { should_not be_valid }
    end
  end

  describe "paragraph associations" do
    before { page.save }
    let!(:second_paragraph) do
      FactoryGirl.create(:paragraph, static_page: page, order: 1)
    end
    let!(:first_paragraph) do
      FactoryGirl.create(:paragraph, static_page: page, order: 0)
    end

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
# Table name: static_pages
#
#  id         :integer(4)      not null, primary key
#  name       :string(30)      not null
#  title      :string(100)     not null
#  heading    :string(100)
#  text       :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

