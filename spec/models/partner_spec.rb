require 'spec_helper'

describe Partner do
  let(:partner) { build(:partner) }

  subject { partner }

  it { should respond_to(:name) }
  it { should respond_to(:url) }
  it { should respond_to(:order) }
  it { should respond_to(:image) }

  it { should be_valid }

  describe "when name" do
    describe "is not present" do
      before { partner.name = "" }
      it { should_not be_valid }
    end
  end

  describe "when url" do
    describe "is not present" do
      before { partner.url = "" }
      it { should_not be_valid }
    end

    describe "is not of valid URI format" do
      let(:invalid_uris) { ["www.google.de"] }
      it "should not be valid" do
        invalid_uris.each do |uri|
          partner.url = uri
          partner.should_not be_valid
        end
      end
    end    
  end

  describe "when order" do
    describe "is not present" do
      before { partner.order = nil }
      it { should_not be_valid }
    end

    describe "is not an integer" do
      before { partner.order = 2.3 }
      it { should_not be_valid }
    end
  end

  describe "association to partner image" do
    before { partner.save! }
    let!(:image) { create(:partner_image, attachable: partner) }
    
    its(:image) { should == image }

    it "should delete the associated image" do
      expect { partner.destroy }.to change(PartnerImage, :count).by(-1)
    end
  end

  describe "default scope" do
    before { partner.save! }
    let!(:other_partner) { create(:partner, order: partner.order - 1) }
    it "should order ascending by order" do
      Partner.all.should == [other_partner, partner]
    end
  end
end
