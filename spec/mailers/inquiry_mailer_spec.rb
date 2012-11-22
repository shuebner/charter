# encoding: utf-8
require "spec_helper"

describe InquiryMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  describe "general_inquiry" do
    let(:inquiry) do
      Inquiry.create!(first_name: 'Hans', last_name: 'Müller', 
        email: 'HansMueller@gmx.de', text: 'Ich will segeln')
    end
    let(:mail) { InquiryMailer.general_inquiry(inquiry) }

    subject { mail }

    it { should deliver_to('anfragen@palve-charter.de') }
    it { should have_subject('Allgemeine Anfrage von Hans Müller') }
    it { should have_body_text('Ich will segeln') }
    it { should have_body_text('hansmueller@gmx.de') }
  end
end
