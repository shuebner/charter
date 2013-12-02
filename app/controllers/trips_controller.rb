
class TripsController < ApplicationController
  def index
    @single_trips = Trip.single.visible.order('name ASC')
    @composite_trips = CompositeTrip.visible.order('name ASC')
  end

  def show
    @trip = Trip.single.visible.find_by_slug(params[:id]) || not_found
    @boat = @trip.boat
    @trip_dates = @trip.trip_dates.in_current_period.order('start_at ASC')
  end
end
