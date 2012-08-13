include ApplicationHelper

class Paragraph < ActiveRecord::Base
  attr_accessible :heading, :text, :order
  belongs_to :static_page
  default_scope order: 'paragraphs.order ASC'

  validates :static_page_id,
    presence: true

  validates :heading,
    length: { maximum: 255 },
    # match empty string or string that starts with non-whitespace character
    format: { with: /^$|\S(.*)/ }

  validates :order,
    presence: true

  validates :text,
    no_html: true

  before_save do |paragraph|
    paragraph.text = sanitize_paragraph_text text
  end
end
# == Schema Information
#
# Table name: paragraphs
#
#  id             :integer(4)      not null, primary key
#  heading        :string(255)
#  text           :text
#  order          :integer(4)      not null
#  static_page_id :integer(4)      not null
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

