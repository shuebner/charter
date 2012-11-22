
class InquiriesController < ApplicationController

  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(params[:inquiry])
    if @inquiry.save
      InquiryMailer.general_inquiry(@inquiry).deliver
      render 'create'
    else
      render 'new'
    end
  end
end
