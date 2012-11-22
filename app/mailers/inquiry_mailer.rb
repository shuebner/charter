class InquiryMailer < ActionMailer::Base
  default from: 'mailer@palve-charter.de'
  default to: 'anfragen@palve-charter.de'

  def general_inquiry(inquiry)
    @inquiry = inquiry
    mail(subject: "Allgemeine Anfrage von #{inquiry.first_name} #{inquiry.last_name}")
  end
end
