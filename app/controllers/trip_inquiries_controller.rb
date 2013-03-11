
class TripInquiriesController < ApplicationController

  def new
    @trip_date = TripDate.effective.find_by_id(params[:trip_date_id]) || not_found
    @trip_inquiry = TripInquiry.new(trip_date_id: @trip_date.id)
  end

  def create
    @trip_inquiry = TripInquiry.new(params[:trip_inquiry])
    if @trip_inquiry.save
      InquiryMailer.trip_inquiry(@trip_inquiry).deliver
      render 'create'
    else
      @trip_date = TripDate.find_by_id(params[:trip_inquiry][:trip_date_id])
      render 'new'
    end
  end
end
