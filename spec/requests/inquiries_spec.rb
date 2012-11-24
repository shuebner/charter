# encoding: utf-8
require 'spec_helper'

describe "Inquiries" do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  subject { page }

  describe "general inquiry" do
    before { visit new_inquiry_path }
    
    it "should not generate an inquiry on invalid form submit" do
      expect do
        submit_form
      end.not_to change(Inquiry, :count)
    end

    it "should generate an inquiry on valid form submit" do
      expect do
        fill_in_and_submit_form
      end.to change(Inquiry, :count).by(1)
    end

    it "should send an email with the form data" do
      # expect
      InquiryMailer.should_receive(:general_inquiry).and_return(double("mailer", deliver: true))
      # when
      fill_in_and_submit_form
    end
  end

  def fill_in_and_submit_form
    fill_in_form
    submit_form
  end

  def fill_in_form
    fill_in 'Vorname', with: 'Hans'
    fill_in 'Nachname', with: 'Müller'
    fill_in 'E-Mail-Adresse', with: 'HansMueller@beispiel.de'
    fill_in 'Nachricht', with: 'Ich will segeln!'
  end

  def submit_form
    click_button 'Absenden'
  end
end