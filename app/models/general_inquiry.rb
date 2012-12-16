class GeneralInquiry < Inquiry
  default_scope where(type: "GeneralInquiry")

  before_save { self.type = "GeneralInquiry" }
end
