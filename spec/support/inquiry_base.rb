# encoding: utf-8
shared_examples_for Inquiry do

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:text) }

  it { should be_valid }

  describe "when type is not present" do
    before { inquiry.type = nil }
    it { should_not be_valid }
  end

  describe "when first name" do
    describe "is not present" do
      before { inquiry.first_name = nil }
      it { should_not be_valid }
    end

    describe "has the wrong format" do
      let(:invalid_names) { %w[hans Ha2ns Ha#ns] }
      it "should not be valid" do
        invalid_names.each do |n|
          inquiry.first_name = n
          inquiry.should_not be_valid
        end
      end
    end

    describe "has the right format" do
      let(:valid_names) { %w[Hans Hößuź Frank-Wilhelm] }
      it "should be valid" do        
        valid_names.each do |n|
          inquiry.first_name = n
          inquiry.should be_valid
        end
      end      
    end
  end

  describe "when last name" do
    describe "is not present" do
      before { inquiry.last_name = nil }
      it { should_not be_valid }
    end

    describe "has the wrong format" do
      let(:invalid_names) { %w[Mei2er Mei#er] }
      it "should not be valid" do
        invalid_names.each do |n|
          inquiry.last_name = n
          inquiry.should_not be_valid
        end
      end
    end

    describe "has the right format" do
      let(:valid_names) { ["d'Agostino", "van de Gulden", "Hößuź-Wilhelmi"] }
      it "should be valid" do
        valid_names.each do |n|
          inquiry.last_name = n
          inquiry.should be_valid
        end
      end
    end
  end

  describe "when email" do
    describe "is not present" do
      before { inquiry.email = nil }
      it { should_not be_valid }
    end

    describe "format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
          foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |a|
          inquiry.email = a
          inquiry.should_not be_valid
        end
      end
    end

    describe "format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org
          frst.last@foo.jp a+b@baz.cn]
        addresses.each do |a|
          inquiry.email = a
          inquiry.should be_valid
        end
      end
    end

    describe "is mixed case then after saving" do
      before do
        inquiry.email = "HansMueller@gmx.de"
        inquiry.save!
      end
      it "should be lower case" do
        inquiry.email.should == "hansmueller@gmx.de"
      end
    end
  end

  describe "when text contains HTML" do
    before do
      inquiry.text = "<h2>Hallo</h2>"
    end
    it "should be sanitized on save" do
      inquiry.save!
      inquiry.text.should == "Hallo"
    end
  end

  describe "method full_name" do
    it "should return the full name" do
      inquiry.full_name.should == "#{inquiry.first_name} #{inquiry.last_name}"
    end
  end
end