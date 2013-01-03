module BoatsHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end

  # custom options for this calendar
  def default_calendar_options
    { 
      :year => @year,
      :month => @month,
      width: 300,
      height: 300,
      :first_day_of_week => 1,
      :event_strips => @event_strips,
      #:month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      #:previous_month_text => "<< " + month_link(@shown_month.prev_month),
      #:next_month_text => month_link(@shown_month.next_month) + " >>"
    }
  end

  def event_calendar(options)
    calendar default_calendar_options.merge(options) do |args|
      event = args[:event]
      html = %(<span title="#{event.begin_date.hour} - #{event.end_date.hour}">)
      html << "#{event.name}"
      html << "</span>"
    end
  end
end