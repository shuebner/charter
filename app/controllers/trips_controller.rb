
class TripsController < ApplicationController
  def index
    @trips = Trip.visible
  end

  def show
    @trip = Trip.visible.find_by_slug(params[:id]) || not_found
  end
end
