require 'spec_helper'

describe BlogEntry do
  
  let(:entry) { build(:blog_entry) }

  subject { entry }

  it { should respond_to(:heading) }
  it { should respond_to(:text) }
  
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
end
