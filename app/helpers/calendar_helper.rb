# encoding: utf-8

module CalendarHelper
  include EventCalendar::CalendarHelper

  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end

  # custom options for this calendar
  def event_calendar_options
    { 
      #year: @year,
      #month: @month,
      first_day_of_week: 1,
      width: 300,
      height: 300,
      #event_strips: @event_strips,
      #month_name_text: I18n.localize(@shown_month, :format => "%B %Y"),
      #previous_month_text: "<< " + month_link(@shown_month.prev_month),
      #next_month_text: month_link(@shown_month.next_month) + " >>"
    }
  end

  def event_calendar(options)
    calendar event_calendar_options.merge(options) do |args|
      event = args[:event]
      event.type == 'BoatBooking' ? 'Schiffscharter' : event.trip.name
    end
  end
end