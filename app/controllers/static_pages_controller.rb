
class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.find_by_slug(params[:id]) || not_found
  end

  def home
    @page = StaticPage.find_by_slug('start') || not_found
    @composite_trips = CompositeTrip.active
  end
end
