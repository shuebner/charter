
class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find_by_slug(params[:id]) || not_found
    @boat = @trip.boat
    @trip_dates = @trip.trip_dates.order('start_at ASC')
  end
end
