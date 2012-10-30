
class BoatsController < ApplicationController

  def index
    @boats = Boat.visible
  end

  def show
    @boat = Boat.visible.find_by_slug(params[:id]) || not_found
  end
end
