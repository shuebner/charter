require 'spec_helper'

describe BlogEntryComment do
  
  let(:entry) { create(:blog_entry) }
  let(:comment) { build(:blog_entry_comment, blog_entry: entry) }

  subject { comment } 

  it { should respond_to(:author) }
  it { should respond_to(:text) }
  its(:entry) { should == entry }

  it { should be_valid }

  [:author, :text].each do |a|
    describe "when #{a.to_s} is empty" do
      before { comment[a] = "" }
      it { should_not be_valid }
    end
    describe "when #{a.to_s} contains HTML" do
      before { comment[a] = "<p>Hallo<p>" }
      it "shouldbe sanitized on save" do
        comment.save!
        comment[a].should == "Hallo"
      end
    end
  end
end
