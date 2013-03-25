class CompositeTripsController < ApplicationController
  def show
    @ctrip = CompositeTrip.visible.find_by_slug(params[:id]) || not_found
    @trips = @ctrip.trips.visible.joins(:trip_dates).order('view_trip_dates.start_at ASC')
  end
end