include ApplicationHelper

class StaticPage < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  attr_accessible :heading, :slug, :text, :title, :paragraphs_attributes,
    :picture, :picture_name, :remove_picture, :retained_picture
  has_many :paragraphs, dependent: :destroy
  accepts_nested_attributes_for :paragraphs, allow_destroy: true
  image_accessor :picture do
    storage_path { |p| "static_page/#{slug}/#{rand(100)}_#{p.name}" }
  end

  validates :title,
    presence: true,
    length: { maximum: 100 }

  validates :heading,
    length: { maximum: 100 },
    # match empty string or string that starts with non-whitespace character
    format: { with: /^$|\S(.*)/ }    

  validates :text,
    constricted_html: true

  before_save do |page|
    page.text = sanitize_page_text text
  end
end

# == Schema Information
#
# Table slug: static_pages
#
#  id         :integer(4)      not null, primary key
#  slug       :string(30)      not null
#  title      :string(100)     not null
#  heading    :string(100)
#  text       :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

