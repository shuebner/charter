require 'spec_helper'

describe BlogEntry do
  
  let(:category) { create(:blog_category) }
  let(:entry) { build(:blog_entry, blog_category: category) }

  subject { entry }

  it { should respond_to(:heading) }
  it { should respond_to(:text) }
  it { should respond_to(:images) }
  it { should respond_to(:blog_category) }
  it { should respond_to(:category) }

  its(:category) { should == category }
  
  it { should be_valid }

  [:heading, :text].each do |a|
    describe "when #{a.to_s} is empty" do
      before { entry[a] = nil }
      it { should_not be_valid }
    end
  end

  [:heading, :text].each do |a|
    describe "when #{a.to_s} contains HTML" do
      before { entry[a] = "<b>Name</b>" }
      it "should be sanitized on save" do
        entry.save
        entry[a].should == "Name"
      end
    end
  end

  it_should_behave_like "activatable", BlogEntry

  it_should_behave_like "imageable", :blog_entry, :blog_entry_image
end
