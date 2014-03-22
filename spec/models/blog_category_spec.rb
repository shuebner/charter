require 'spec_helper'

describe BlogCategory do
  let(:category) { build(:blog_category) }

  subject { category }

  it { should respond_to(:name) }
  it { should respond_to(:blog_entries) }
  it { should respond_to(:entries) }

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

  describe "BlogEntry association" do
    let!(:entry1) { create(:blog_entry, blog_category: category) }
    let!(:entry2) { create(:blog_entry, blog_category: category) }
    it "should have the right entries" do
      category.entries.sort.should =~ [entry1, entry2].sort
    end
    describe "deletion" do
      describe "without entries" do
        let!(:category_without_entries) { create(:blog_category) }
        it "should be allowed" do
          expect { category_without_entries.destroy }.to change(BlogCategory, :count).by(-1)
        end
      end
      describe "with entries" do
        before { category.save }
        it "should not be allowed" do
          expect { category.destroy }.not_to change(BlogCategory, :count)
        end
      end
    end
  end

  describe "scope" do
    describe "temporal" do

      describe "if there are no categories" do
        
        it "latest should return nil" do
          BlogCategory.latest.should be_nil
        end
        
        it "by_time should return empty array" do
          BlogCategory.by_time.should be_empty
        end
      end

      describe "if there are categories" do
        let!(:latest_category) { create(:blog_category) }
        let!(:past_category) { create(:blog_category,
          updated_at: latest_category.updated_at - 1.month) }
        
        it "latest should return the category with the most recently updated entry" do
          BlogCategory.latest.should == latest_category
        end

        it "by_time should return all categories descending by updated_at" do
          BlogCategory.by_time.should == 
            [latest_category, past_category]
        end
      end
    end
  
    describe "others" do
      let!(:category) { create(:blog_category) }
      let!(:other_category) { create(:blog_category) }
      it "should return all categories except the one given" do
        BlogCategory.others(category).should == [other_category]
      end
    end
  end
end
