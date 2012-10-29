# encoding: utf-8
include ActionView::Helpers::SanitizeHelper
include ActionView::Helpers::NumberHelper

module ApplicationHelper
  def base_title
    "Palve-Charter Ostsee"
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
    precisions = Charter::Application.config.precisions
    number_with_precision(number, precision: precisions[options[:as]])
  end

  def num_with_del_and_u(number, options = {})
    units = Charter::Application.config.units
    "#{num_with_del(number, options)} #{units[options[:as]]}"
  end
end
