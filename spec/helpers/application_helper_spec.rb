# encoding: utf-8
require 'spec_helper'

describe ApplicationHelper do
  describe "full_title" do
    it "should include the page title" do
      full_title("bla").should =~ /bla/
    end

    it "should include the base title" do
      full_title("bla").should =~ /^#{base_title}/
    end

    it "should not include a bar for the home page" do
      full_title("").should_not =~ /\|/
    end
  end

  describe "sanitize_page_text" do
    it "should remove forbidden HTML tags" do
      sanitize_page_text("<script>bla</script>").should_not =~ /<script>/
    end

    it "should not remove allowed HTML tags" do
      Charter::Application.config.allowed_tags_in_page_text.each do |tag|
        sanitize_page_text("<#{tag}>").should =~ /<#{tag}>/
      end
    end
  end

  describe "num_with_del" do
    [:linear, :area, :volume, :mass].each do |option|
      describe "when called with #{option.to_s}" do
        let!(:formats) { Charter::Application.config.num_formats }
        it "should show the number with the right precision" do
          precision = formats[option][:precision]
          fraction = precision > 0 ? ",#{0.to_s * precision}" : ''
          num_with_del(3, { as: option }).should == "3#{fraction}"
        end
      end
    end
  end

  describe "num_with_del_and_u" do
    [:linear, :area, :volume, :mass].each do |option|
      describe "when called with #{option.to_s}" do
        let!(:formats) { Charter::Application.config.num_formats }
        it "should show the number with the right precision and unit" do
          unit = formats[option][:unit]
          number_with_del = num_with_del(3, { as: option})
          num_with_del_and_u(3, { as: option}).should == "#{number_with_del} #{unit}"
        end
      end
    end
  end
end