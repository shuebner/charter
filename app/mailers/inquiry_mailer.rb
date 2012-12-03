# encoding: utf-8
class InquiryMailer < ActionMailer::Base
  default from: 'mailer@palve-charter.de'
  default to: 'klaus.wenz@palve-charter.de'

  def general_inquiry(inquiry)
    @inquiry = inquiry
    mail(subject: "Allgemeine Anfrage von #{inquiry.full_name}")
  end

  def trip_inquiry(inquiry)
    @inquiry = inquiry
    trip_name = inquiry.trip_date.display_name_with_trip
    mail(subject: "Törnanfrage zu #{trip_name} von #{inquiry.full_name}")
  end
end
