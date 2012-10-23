require 'spec_helper'

describe Attachment do
  let(:attachment) { build(:attachment) }

  subject { attachment }

  it { should respond_to(:type) }
  it { should respond_to(:attachable_id) }
  it { should respond_to(:attachable_type) }
  it { should respond_to(:attachment_name) }
  it { should respond_to(:attachment_uid) }
  it { should respond_to(:attachment_title) }
  it { should respond_to(:attachment) }
  it { should respond_to(:remove_attachment) }
  it { should respond_to(:retained_attachment) }

  it { should be_valid }

  describe "accessible attributes" do
    [:type, :attachable_id, :attachable_type, :attachment_uid, 
      :attachment_name].each do |a|
      it "should not allow access to #{a}" do
        expect do
          Attachment.new(a.to_sym => "")
        end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
    [:remove_attachment, :retained_attachment].each do |a|
      it "should allow access to #{a}" do
        expect do
          Attachment.new(a.to_sym => "")
        end.not_to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  [:attachable_id, :attachable_type].each do |a|
    describe "when #{a}" do
      describe "is not present" do
        before { attachment[a] = "" }
        it { should_not be_valid }
      end
    end
  end

  describe "when attachment title" do
    describe "is not present" do
      before { attachment.attachment_title = "" }
      it { should_not be_valid }
    end
    describe "contains HTML" do
      before { attachment.attachment_title = "<p>Hallo</p>" }
      it "should be sanitized on save" do
        attachment.save
        attachment.attachment_title.should == "Hallo"
      end
    end
  end
end