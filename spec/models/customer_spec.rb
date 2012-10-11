# encoding: utf-8
require 'spec_helper'

describe Customer do
  let(:customer) { create(:customer) }

  let(:invalid_name_chars) do
    '!"§$%&/=?,.;:_<>|+*~#()[]{}\°0123456789'.each_char
  end
  let(:invalid_street_name_chars) do
    '!"§$%&/=?,;:_<>|+*~#()[]{}\°'.each_char
  end

  subject { customer }

  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :gender }
  it { should respond_to :phone_landline }
  it { should respond_to :phone_mobile }
  it { should respond_to :email }
  it { should respond_to :street_name }
  it { should respond_to :street_number }
  it { should respond_to :zip_code }
  it { should respond_to :city }
  it { should respond_to :country }

  it { should respond_to :street }
  it { should respond_to :full_name }
  
  it { should be_valid }

  describe "when first name" do
    describe "is not present" do
      before { customer.first_name = "" }
      it { should_not be_valid }
    end

    describe "is too short" do
      before { customer.first_name = "A"*1 }
      it { should_not be_valid }
    end
    
    describe "does not begin with a capital" do
      before { customer.first_name = "hans" }
      it { should_not be_valid }      
    end
    
    describe "contains invalid characters" do
      it "it should not be valid" do
        invalid_name_chars.each do |c|
          customer.first_name = ("Hans" + c)
          customer.should_not be_valid
        end
      end
    end

    describe "does contain umlauts and accented letters" do
      it "should be valid" do
        valid_names = %w[Könänü-Ók Húßùl]
        valid_names.each do |n|
          customer.first_name = n
          customer.should be_valid
        end        
      end
    end
  end

  describe "when last name" do
    describe "is not present" do
      before { customer.last_name = "" }
      it { should_not be_valid }
    end

    describe "is too short" do
      before { customer.last_name = "A" }
      it { should_not be_valid }
    end

    describe "contains invalid characters" do
      it "should not be valid" do
        invalid_name_chars.each do |c|
          customer.last_name = ("Müller" + c)
          customer.should_not be_valid
        end
      end
    end

    describe "does contain umlauts and accented letters" do
      it "should be valid" do
        valid_names = %w[Könänü Húßùl]
        valid_names.each do |n|
          customer.last_name = n
          customer.should be_valid
        end        
      end
    end
  end

  describe "when gender" do
    describe "is not present" do
      before { customer.gender = nil }
      it { should_not be_valid }
    end
    describe "is invalid" do
      before { customer.gender = "n" }
      it { should_not be_valid }
    end
  end

  describe "when phone number" do
    [:phone_landline, :phone_mobile].each do |p|
      describe "#{p} contains invalid characters" do
        it "should not be valid" do
          ['aA!"§$%&/()=?,;:_#*~ '].each do |c|            
            customer[p] = "0371-12345678" + c
            customer.should_not be_valid
          end
        end
      end

      describe "#{p} has the wrong format" do
        it "should not be valid do" do
          invalid_numbers = ["0371 2345678", "0371-234-564"]
          invalid_numbers.each do |n|
            customer[p] = n
            customer.should_not be_valid
          end
        end
      end

      describe "#{p} has the right format" do
        it "should be valid" do
          valid_numbers = %w[+49371-12345678 0371-12345978]
          valid_numbers.each do |n|
            customer[p] = n
            customer.should be_valid
          end
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
          customer.email = a
          customer.should_not be_valid
        end
      end
    end

    describe "format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org
          frst.last@foo.jp a+b@baz.cn]
        addresses.each do |a|
          customer.email = a
          customer.should be_valid
        end
      end
    end

    describe "is mixed case then after saving" do
      before do
        customer.email = "HansMueller@gmx.de"
        customer.save
      end
      it "should be lower case" do
        customer.email.should == "hansmueller@gmx.de"
      end
    end
  end

  describe "when street_name" do
    describe "contains invalid characters" do
      it "should not be valid" do
        invalid_street_name_chars.each do |c|
          customer.street_name = "Hauptstraße" + c
          customer.should_not be_valid
        end
      end
    end

    describe "has the right format" do
      it "should be valid" do
        street_names = ["Straße der Nationen", "14.-Juni-Straße",
          "Platz des d'Augústus"]
        street_names.each do |n|
          customer.street_name = n
          customer.should be_valid
        end
      end
    end
  end

  describe "when street number" do
    describe "has the wrong format" do
      it "should not be valid" do
        invalid_numbers = %w[12-a a a13]
        invalid_numbers.each do |n|
          customer.street_number = n
          customer.should_not be_valid
        end
      end
    end
    describe "has the right format" do
      it "should be valid" do
        valid_numbers = %w[12 17a 27B]
        valid_numbers.each do |n|
          customer.street_number = n
          customer.should be_valid
        end
      end
    end
  end

  describe "when zip code" do
    describe "has the wrong length" do
      it "should not be valid" do
        [1, 2, 3, 4, 6, 7].each do |n|
          customer.zip_code = "3" * n
          customer.should_not be_valid
        end
      end
    end
    describe "has the wrong format" do
      it "should not be valid" do
        invalid_zip_codes = %w[12a45 12-45 00123]
        invalid_zip_codes.each do |z|
          customer.zip_code = z
          customer.should_not be_valid
        end
      end
    end
    describe "has the right format" do
      it "should be valid" do
        valid_zip_codes = %w[01234 98765]
        valid_zip_codes.each do |z|
          customer.zip_code = z
          customer.should be_valid
        end
      end
    end
  end

  [:city, :country].each do |c|
    describe "when #{c}" do
      describe "has the wrong format" do
        it "should not be valid" do
          invalid_names = %w[Chemn8nitz deutschland ]
          invalid_names.each do |n|
            customer[c] = n
            customer.should_not be_valid
          end
        end
      end
      describe "has the right format" do
        it "should be valid" do
          valid_names = ["Deutschland", "Burkina Faso", "Annaberg-Buchholz"]
          valid_names.each do |n|
            customer[c] = n
            customer.should be_valid
          end
        end
      end
    end
  end

  describe "calculated fields" do
    describe "street" do
      before do
        customer.street_name = "Fürstenstraße"
        customer.street_number = "14a"
      end
      its(:street) { should == "Fürstenstraße 14a" }
    end

    describe "full name" do
      before do
        customer.first_name = "Hans"
        customer.last_name = "Albers"
      end
      its(:full_name) { should == "Hans Albers" }
    end
  end

  describe "default sort order" do
    let!(:customer3) { create(:customer, last_name: "Zeppelin", first_name: "Ferdinand") }
    let!(:customer2) { create(:customer, last_name: "Aschoff", first_name: "Zacharias") }
    let!(:customer1) { create(:customer, last_name: "Aschoff", first_name: "Adalbert") }

    it "should sort ascending by first name, then ascending by last name" do
      Customer.all.should == [customer1, customer2, customer3]
    end
  end
end
