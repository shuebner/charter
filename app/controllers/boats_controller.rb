
class BoatsController < ApplicationController

  def index
    @own_ports = Port.own.with_visible_boat
    @external_ports = Port.external.with_visible_boat
  end

  def show
    @boat = Boat.visible.find_by_slug(params[:id]) || not_found
    if @boat.available_for_boat_charter
      @seasons = Season.all
      @boat_price_types = BoatPriceType.all
    end


    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)
    @first_day_of_week = 1

    @event_strips = BoatBooking.event_strips_for_month(@shown_month, @first_day_of_week,
      conditions: "boat_id = #{@boat.id}")
  end
end
