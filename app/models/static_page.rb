include ApplicationHelper

class StaticPage < ActiveRecord::Base
  attr_accessible :heading, :name, :text, :title

  validates :name,
    presence: true,
    length: { maximum: 30 },
    uniqueness: true

  validates :title,
    presence: true,
    length: { maximum: 100 }

  validates :heading,
    length: { maximum: 100 }

  validates :text,
    constricted_html: true

  before_save do |page|
    page.name = name.downcase
    page.text = sanitize_text text
  end
end

# == Schema Information
#
# Table name: static_pages
#
#  id         :integer(4)      not null, primary key
#  name       :string(30)      not null
#  title      :string(100)     not null
#  heading    :string(100)
#  text       :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

