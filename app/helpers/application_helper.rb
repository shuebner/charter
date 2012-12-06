# encoding: utf-8
include ActionView::Helpers::SanitizeHelper
include ActionView::Helpers::NumberHelper

module ApplicationHelper
  def base_title
    "Palve-Charter - Segeln auf der Ostsee"
  end

  def full_title(title)
    if title.blank?
      base_title
    else
      base_title + " | " + (title)
    end
  end

  def sanitize_page_text (text)
    sanitize text, tags: Charter::Application.config.allowed_tags_in_page_text
  end

  def num_with_del(number, options = {})
    precision = Charter::Application.config.num_formats[options[:as]][:precision]
    number_with_precision(number, precision: precision)
  end

  def num_with_del_and_u(number, options = {})
    unit = Charter::Application.config.num_formats[options[:as]][:unit]
    "#{num_with_del(number, options)} #{unit}"
  end
end
