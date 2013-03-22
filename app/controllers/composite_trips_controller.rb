class CompositeTripsController < ApplicationController
  def show
    @ctrip = CompositeTrip.visible.find_by_slug(params[:id]) || not_found
  end
end