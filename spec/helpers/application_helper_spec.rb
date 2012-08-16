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

  describe "sanitize_paragraph_text" do
    it "should remove forbidden HTML tags" do
      sanitize_paragraph_text("<script>bla</script>").should_not =~ /<script>/
    end

    it "should not remove allowed HTML tags" do
      Charter::Application.config.allowed_tags_in_paragraph_text.each do |tag|
        sanitize_paragraph_text("<#{tag}>").should =~ /<#{tag}>/
      end
    end
  end
end