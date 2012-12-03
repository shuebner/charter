# encoding: utf-8
require 'spec_helper'
require 'inquiry_form_helper'

shared_examples_for "inquiries request" do |inquiry_class, mailer_method, additional_form_actions|
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include InquiryFormHelper

  let(:additional_form_actions) { additional_form_actions }

  describe "on invalid form submit" do
    it "should not generate an inquiry" do
      expect do
        submit_form
      end.not_to change(inquiry_class, :count)
    end

    it "should redirect to the form" do
      submit_form
      page.should have_content('stellen')
    end
  end

  describe "on valid form submit" do
    it "should generate an inquiry" do
      expect do
        fill_and_submit
      end.to change(inquiry_class, :count).by(1)
    end

    it "should show success page" do
      fill_and_submit
      page.should have_content('erfolgreich')
    end

    it "should send an email with the form data" do
      # expect
      InquiryMailer.should_receive(mailer_method).and_return(double("mailer", deliver: true))
      # when
      fill_and_submit
    end
  end

  def fill_and_submit
    fill_in_and_submit_form(additional_form_actions)
  end
end