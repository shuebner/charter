
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
  end
end
