require 'spec_helper'

describe Document do
  let(:doc) { build(:document) }

  subject { doc }

  it_should_behave_like Attachment

  it { should be_valid }

  describe "when type is not present" do
    before { doc.type = "" }
    it { should_not be_valid }
  end

  describe "attachment_uid" do
    it "should be set on save" do
      doc.save
      doc.attachment_uid.should_not be_blank
    end
  end
end
