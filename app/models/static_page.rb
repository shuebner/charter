include ApplicationHelper

class StaticPage < ActiveRecord::Base
  attr_accessible :heading, :slug, :text, :title, :paragraphs_attributes
  has_many :paragraphs, dependent: :destroy
  accepts_nested_attributes_for :paragraphs, allow_destroy: true

  validates :slug,
    presence: true,
    length: { maximum: 30 },
    uniqueness: true

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
    page.slug = slug.downcase
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

