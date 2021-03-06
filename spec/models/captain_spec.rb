# encoding: utf-8
require 'spec_helper'

describe Captain do
  let(:captain) { build(:captain) }

  subject { captain }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:phone_mobile) }
  it { should respond_to(:email) }
  it { should respond_to(:sailing_certificates) }
  it { should respond_to(:additional_certificates) }
  it { should respond_to(:description) }
  it { should respond_to(:slug) }

  it { should be_valid }

  describe "when first name" do
    describe "is not present" do
      before { captain.first_name = nil }
      it { should_not be_valid }
    end

    describe "has the wrong format" do
      let(:invalid_names) { %w[hans Ha2ns Ha#ns] }
      it "should not be valid" do
        invalid_names.each do |n|
          captain.first_name = n
          captain.should_not be_valid
        end
      end
    end

    describe "has the right format" do
      let(:valid_names) { %w[Hans Hößuź Frank-Wilhelm] }
      it "should be valid" do        
        valid_names.each do |n|
          captain.first_name = n
          captain.should be_valid
        end
      end      
    end
  end

  describe "when last name" do
    describe "is not present" do
      before { captain.last_name = nil }
      it { should_not be_valid }
    end

    describe "has the wrong format" do
      let(:invalid_names) { %w[Mei2er Mei#er] }
      it "should not be valid" do
        invalid_names.each do |n|
          captain.last_name = n
          captain.should_not be_valid
        end
      end
    end

    describe "has the right format" do
      let(:valid_names) { ["d'Agostino", "van de Gulden", "Hößuź-Wilhelmi"] }
      it "should be valid" do
        valid_names.each do |n|
          captain.last_name = n
          captain.should be_valid
        end
      end
    end
  end

  describe "when phone_mobile" do
    describe "is not present" do
      before { captain.phone_mobile = nil }
      it { should_not be_valid }
    end

    describe "has the wrong format" do
      let(:invalid_numbers) { %w[12a3-123456 0123-12#4] }
      it "should not be valid" do
        invalid_numbers.each do |n|
          captain.phone_mobile = n
          captain.should_not be_valid
        end        
      end
    end

    describe "has the right format" do
      let(:valid_numbers) { %w[0221-1345558 +49371-123645] }
      it "should be valid" do
        valid_numbers.each do |n|
          captain.phone_mobile = n
          captain.should be_valid
        end
      end
    end
  end

  describe "when email" do
    describe "format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
          foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |a|
          captain.email = a
          captain.should_not be_valid
        end
      end
    end

    describe "format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org
          frst.last@foo.jp a+b@baz.cn]
        addresses.each do |a|
          captain.email = a
          captain.should be_valid
        end
      end
    end

    describe "is mixed case then after saving" do
      before do
        captain.email = "HansMueller@gmx.de"
        captain.save
      end
      it "should be lower case" do
        captain.email.should == "hansmueller@gmx.de"
      end
    end
  end

  describe "when description contains forbidden HTML" do
    before do
      captain.description = "<li>Hallo<br>Du</li>"
    end
    it "should be sanitized on save" do
      captain.save
      captain.description.should == "Hallo<br>Du"
    end
  end

  describe "slug should be first and last name" do
    before do
      captain.first_name = "Hans"
      captain.last_name = "Schmidt"
      captain.save
    end
    its(:slug) { should == "hans-schmidt" }
  end

  describe "calculated fields" do
    describe "full name" do
      it "should give first name and last name" do
        captain.full_name.should == "#{captain.first_name} #{captain.last_name}"
      end
    end

    [:sailing_certificates, :additional_certificates].each do |a|
      describe "#{a.to_s}_array" do
        before { captain[a] = "SKS;SBF See; Signal-Waffen-Zeugnis" }
        it "should give the single certificates as fields in an array" do
          captain.send("#{a.to_s}_array".to_sym).should == 
            ["SKS", "SBF See", "Signal-Waffen-Zeugnis"]
        end
      end
    end
  end

  describe "association" do
    describe "with image" do
      before { captain.save! }
      let!(:image) { create(:captain_image, attachable: captain) }
      it "should have the right image" do
        captain.image.should == image
      end
      it "should delete associated images" do
        expect { captain.destroy }.to change(CaptainImage, :count).by(-1)
      end
    end
  end
end
