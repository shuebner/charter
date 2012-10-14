include ApplicationHelper

class Paragraph < ActiveRecord::Base
  attr_accessible :heading, :text, :order, :picture, :picture_name, 
    :remove_picture, :retained_picture
  belongs_to :static_page
  image_accessor :picture do
    storage_path { |p| "static_page/#{static_page.slug}/#{order}/#{rand(100)}_#{p.name}" }
  end
  default_scope order: 'paragraphs.order ASC'

  validates :static_page_id,
    presence: true

  validates :heading,
    length: { maximum: 255 },
    # match empty string or string that starts with non-whitespace character
    format: { with: /^$|\S(.*)/ }

  validates :order,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 },
    uniqueness: { scope: :static_page_id }

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

