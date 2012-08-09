require 'spec_helper'

describe StaticPage do
  before { @static_page = StaticPage.new(name: 'start', title: 'Willkommen', 
    heading: 'Segeln mit Palve-Charter', 
    text: %#<h2>Hallo</h2><h3>zusammen</h3><p><a href="www.google.de">Test</a></p>#) }

  subject { @static_page }

  it { should respond_to(:name) }
  it { should respond_to(:title) }
  it { should respond_to(:heading) }
  it { should respond_to(:text) }

  it { should be_valid }

  describe "when name" do
    describe "is not present" do
      before { @static_page.name = " " }
      it { should_not be_valid }
    end

    describe "is too long" do
      before { @static_page.name = 'a' * 31 }
      it { should_not be_valid}
    end

    describe "already exists" do
      before do 
        @static_page_with_same_title = @static_page.dup
        @static_page_with_same_title.name = @static_page_with_same_title.name.upcase
        @static_page_with_same_title.save
      end
      it { should_not be_valid }
    end
  end

  describe "when title" do
    describe "is not present" do
      before { @static_page.name = " " }
      it { should_not be_valid }
    end

    describe "is too long" do
      before { @static_page.title = 'a' * 101 }
      it { should_not be_valid }
    end
  end

  describe "when heading" do
    describe "is to long" do
      before { @static_page.heading = 'a' * 101 }
      it { should_not be_valid}
    end
  end

  describe "when text" do
    describe "uses forbidden HTML tags" do
      before { @static_page.text = '<h1>h</h1> blablabla' }
      it { should_not be_valid }
    end
=begin
    describe "uses allowed HTML tags but is not valid HTML because" do
      describe "tags are not closed" do
        before { @static_page.text = '<h2>Moin' }
        it { should_not be_valid }
      end

      describe "the wrong close tag is used" do
        before { @static_page.text = '<h2>Moin</h3>' }
        it { should_not be_valid }
      end      
    end
=end
  end
end
# == Schema Information
#
# Table name: static_pages
#
#  id         :integer(4)      not null, primary key
#  name       :string(30)      not null
#  title      :string(100)     not null
#  heading    :string(100)
#  text       :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

