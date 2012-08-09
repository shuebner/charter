# encoding: utf-8
include ActionView::Helpers::SanitizeHelper

module ApplicationHelper
  def base_title
    "Palve-Charter Müritz"
  end

  def full_title(title)
    if title
      base_title + " | " + (title)
    else
      base_title
    end
  end

  def sanitize_text (text)
    sanitize text, tags: %w(p h2 h3 a)
  end
end
