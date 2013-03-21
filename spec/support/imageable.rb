shared_examples_for "imageable" do |imageable_factory, image_factory|
  
  describe "association with images" do
    let(:imageable) { create(imageable_factory) }

    let!(:image2) { create(image_factory, attachable: imageable, order: 2) }
    let!(:image1) { create(image_factory, attachable: imageable, order: 1) }

    it "should have the right images in the right order" do
      imageable.images.should == [image1, image2]
    end

    it "should delete associated images" do
      expect { imageable.destroy }.to change(image1.class, :count).by(-2)
    end

    describe "title_image" do
      describe "if there is at least one image" do
        it "should return the first image of the imageable" do
          imageable.title_image.should == image1
        end
      end
      describe "if there are no images" do
        before { imageable.images.destroy_all }
        it "should not raise an error and return nil" do
          imageable.title_image.should be_nil
        end
      end
    end

    describe "other_images" do
      describe "if there is at least one other than the title image" do
        it "should return all the images except the title image" do
          imageable.other_images.should == [image2]
        end
      end
      describe "if there are no images except the title image" do
        before { imageable.images.destroy(image2) }
        it "should return an empty array" do
          imageable.other_images.should == []
        end
      end
    end
  end
end