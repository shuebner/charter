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

  describe "when image" do
    describe "is very large" do
      let!(:large_image) do
        create(:image, attachment: File.new("/home/sven/Bilder/too_big.jpg"))
      end
      it "should be resized to a standard maximum size" do
        large_image.attachment.width.should <= 1600
        large_image.attachment.height.should <= 1200
      end
    end
    describe "is small enough" do
      it "should not be resized" do
        image.attachment.width.should == 563
        image.attachment.height.should == 750
      end
    end
  end
end