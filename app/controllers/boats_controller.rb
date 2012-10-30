
class BoatsController < ApplicationController

  def index
    @boats = Boat.visible
  end

  def show
    @boat = Boat.visible.find_by_slug(params[:id]) || not_found
    if @boat.available_for_boat_charter
      @seasons = Season.all
      @boat_price_types = BoatPriceType.all
    end
  end
end
