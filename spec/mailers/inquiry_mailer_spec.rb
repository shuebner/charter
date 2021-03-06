# encoding: utf-8
require "spec_helper"

describe InquiryMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  shared_examples_for "inquiry_mail" do
    it { should deliver_to('klaus.wenz@palve-charter.de') }
    it { should have_body_text(inquiry.text) }
    it { should have_body_text(inquiry.email) }
    it { should reply_to(inquiry.email) }
  end
  
  describe "general_inquiry" do
    let(:inquiry) { create(:full_general_inquiry) }
    let(:mail) { InquiryMailer.general_inquiry(inquiry) }

    subject { mail }

    it_should_behave_like "inquiry_mail"
    it { should have_subject("Allgemeine Anfrage von #{inquiry.full_name}") }    
  end

  describe "trip_inquiry" do
    let(:trip_date) { create(:trip_date) }
    let(:inquiry) { create(:full_trip_inquiry) }
    let(:mail) { InquiryMailer.trip_inquiry(inquiry) }

    subject { mail }

    it_should_behave_like "inquiry_mail"
    it { should have_subject(
      "Törnanfrage zu #{inquiry.trip_date.display_name_with_trip} von #{inquiry.full_name}") }
    it { should have_body_text("Kojenzahl: #{inquiry.bunks}") }
  end

  describe "boat inquiry" do
    let(:boat) { create(:boat) }
    let(:inquiry) { create(:full_boat_inquiry) }
    let(:mail) { InquiryMailer.boat_inquiry(inquiry) }

    subject { mail }

    it_should_behave_like "inquiry_mail"
    it { should have_subject(
      "Schiffsanfrage für #{inquiry.boat.name} für #{inquiry.time_period_name}") }
    it { should have_body_text("#{inquiry.full_name}") }
  end
end
