require 'spec_helper'

describe BlogCategory do
  let(:category) { build(:blog_category) }

  subject { category }

  it { should respond_to(:name) }

  it { should be_valid }

  describe "when name" do
    describe "is not present" do
      before { category.name = nil }
      it { should_not be_valid }
    end
    describe "contains HTML" do
      before { category.name = "<b>Name</b>" }
      it "should be sanitized on save" do
        category.save
        category.name.should == "Name"
      end
    end
  end
end
