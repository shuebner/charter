
class BoatsController < ApplicationController

  def index
    @boats = Boat.visible
  end

  def show
    @boat = Boat.find(params[:id])
    if @boat.available_for_boat_charter
      @seasons = Season.all
      @boat_price_types = BoatPriceType.all
    end
  end
end
