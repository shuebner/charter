require 'spec_helper'

describe Image do
  let(:image) { build(:image) }

  subject { image }

  it { should be_valid }

  describe "when type is not present" do
    before { image.type = "" }
    it { should_not be_valid }
  end

  describe "attachment_uid" do
    it "should be set on save" do
      image.save
      image.attachment_uid.should_not be_blank
    end
  end
end
