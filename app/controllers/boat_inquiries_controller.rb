
class BoatInquiriesController < ApplicationController

  def new
    @boat = Boat.visible.find_by_slug(params[:boat]) || not_found
    @boat_inquiry = BoatInquiry.new(boat_id: @boat.id)
  end

  def create
    @boat_inquiry = BoatInquiry.new(params[:boat_inquiry])
    if @boat_inquiry.save
      InquiryMailer.boat_inquiry(@boat_inquiry).deliver
      render 'create'
    else
      @boat = Boat.find_by_id(params[:boat_inquiry][:boat_id])
      render 'new'
    end
  end
end
