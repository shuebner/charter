
class BoatsController < ApplicationController

  def index
    if params[:hafen]      
      @port = Port.with_visible_boat.find_by_slug(params[:hafen]) || not_found
      render 'index_single_port'
    else
      @own_ports = Port.with_visible_boat.own
      @external_ports = Port.with_visible_boat.external
    end
  end

  def show
    @boat = Boat.visible.find_by_slug(params[:id]) || not_found
    if @boat.available_for_boat_charter
      @seasons = Season.all
      @boat_price_types = BoatPriceType.all
    end
  end
end
