
class GeneralInquiriesController < ApplicationController

  def new
    @inquiry = GeneralInquiry.new
  end

  def create
    @inquiry = GeneralInquiry.new(params[:general_inquiry])
    if @inquiry.save
      InquiryMailer.general_inquiry(@inquiry).deliver
      render 'create'
    else
      render 'new'
    end
  end
end
