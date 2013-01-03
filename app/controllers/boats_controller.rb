
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

    first_date = Season.order('begin_date ASC').first.begin_date    
    last_date = Season.unscoped.order('end_date DESC').first.end_date

    @calendar_options = Array.new
    
    (first_date.year..last_date.year).each do |y|
      start_month = (first_date.year == y) ? first_date.month : 1
      end_month = (last_date.year == y) ? last_date.month : 12
      
      (start_month..end_month).each do |m|
        shown_month = Date.civil(y, m)
        event_strips = BoatBooking.event_strips_for_month(shown_month, 1,
          conditions: "boat_id = #{@boat.id}")
        
        @calendar_options << { year: y, month: m, 
          month_name_text: I18n.localize(shown_month, :format => "%B %Y"),
          shown_month: shown_month,
          event_strips: event_strips }
      end
    end
  end
end
