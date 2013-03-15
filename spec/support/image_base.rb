require 'spec_helper'

shared_examples_for Image do
  it_should_behave_like Attachment

  it { should be_valid }

  describe "when type is not present" do
    before { subject.type = "" }
    it { should_not be_valid }
  end

  describe "attachment_uid" do
    it "should be set on save" do
      subject.save
      subject.attachment_uid.should_not be_blank
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
        subject.attachment.width.should == 563
        subject.attachment.height.should == 750
      end
    end
  end

  describe "shortcuts" do
    it "should delegate the thumb method" do
      subject.thumb('100x100').url.should == subject.attachment.thumb('100x100').url
    end
  end  
end