
class CalendarsController < ApplicationController

  def update_boat_calendar    
    # retrieve boats that are displayable in this calendar
    @selectable_boats = Boat.own.boat_charter_only.order('model ASC').
      includes(:boat_bookings, :trip_dates)
    
    # retrieve previous selection in the form
    @selected_boats = params[:boat_selection] || Hash[@selectable_boats.map{ |b| [b.slug, b.slug] }]
    scope = @selectable_boats.select('boats.id')
    
    if @selected_boats
      scope = scope.where(slug: @selected_boats.keys)
    end

    selected_boats = scope

    # get all the Appointments to be displayed
    app_ids = []
    selected_boats.each do |boat|
      app_ids += boat.boat_bookings.map(&:id) + boat.trip_dates.booked.map(&:id)      
    end
    apps = Appointment.where(id: app_ids)

    # restrict the calender to the seasons if there are any, else the full year
    if Season.all.any?
      first_date = Season.order('begin_date ASC').first.begin_date
      last_date = Season.unscoped.order('end_date DESC').first.end_date
    else
      first_date = Date.new(Date.today.year, 1, 1)
      last_date = Date.new(Date.today.year, 12, 31)
    end

    @ec_options = Array.new

    (first_date.year..last_date.year).each do |y|
      start_month = (first_date.year == y) ? first_date.month : 1
      end_month = (last_date.year == y) ? last_date.month : 12
      
      (start_month..end_month).each do |m|
        shown_month = Date.civil(y, m)        
        event_strips = apps.event_strips_for_month(shown_month, 1)        

        @ec_options << { year: y, month: m,
          month_name_text: I18n.localize(shown_month, :format => "%B %Y"),
          shown_month: shown_month,
          event_strips: event_strips }
      end
    end
    render 'boats_calendar'
  end
end
