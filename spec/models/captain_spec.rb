# encoding: utf-8
require 'spec_helper'

describe Captain do
  let(:captain) { create(:captain) }

  subject { captain }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:phone) }
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

  describe "when phone" do
    describe "is not present" do
      before { captain.phone = nil }
      it { should_not be_valid }
    end

    describe "has the wrong format" do
      let(:invalid_numbers) { %w[12a3-123456 0123-12#4] }
      it "should not be valid" do
        invalid_numbers.each do |n|
          captain.phone = n
          captain.should_not be_valid
        end        
      end
    end

    describe "has the right format" do
      let(:valid_numbers) { %w[0221-1345558 +49371-123645] }
      it "should be valid" do
        valid_numbers.each do |n|
          captain.phone = n
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
  end
end
