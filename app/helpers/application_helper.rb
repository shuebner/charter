# encoding: utf-8
include ActionView::Helpers::SanitizeHelper

module ApplicationHelper
  def base_title
    "Palve-Charter Müritz"
  end

  def full_title(title)
    if title.blank?
      base_title
    else
      base_title + " | " + (title)
    end
  end

  def sanitize_text (text)
    sanitize text, tags: Charter::Application.config.allowed_tags_in_text
  end
end
