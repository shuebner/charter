
class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find_by_slug(params[:id]) || not_found
  end
end
