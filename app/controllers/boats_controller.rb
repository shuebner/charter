
class BoatsController < ApplicationController

  def index
    @boats = Boat.where(
      "available_for_boat_charter = ? OR available_for_bunk_charter = ?",
      true, true)
  end

  def show
    @boat = Boat.find(params[:id])
  end
end
