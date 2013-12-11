
class TripsController < ApplicationController
  def index
    if params[:schiff]      
      @per_boat = true
      @boat = Boat.active.bunk_charter_only.find_by_slug(params[:schiff]) || not_found
      @single_trips = Trip.single.visible.where(boat_id: @boat.id).order('name ASC')
      @composite_trips = CompositeTrip.visible.where(boat_id: @boat.id).order('name ASC')
    else
      @per_boat = false
      @single_trips = Trip.single.visible.order('name ASC')
      @composite_trips = CompositeTrip.visible.order('name ASC')
    end
  end

  def show
    @trip = Trip.single.visible.find_by_slug(params[:id]) || not_found
    @boat = @trip.boat
    @trip_dates = @trip.trip_dates.in_current_period.order('start_at ASC')
  end
end
