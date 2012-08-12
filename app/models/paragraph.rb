class Paragraph < ActiveRecord::Base
  attr_accessible :heading, :text, :order
  belongs_to :static_page
  default_scope order: 'paragraphs.order ASC'

  validates :static_page_id,
    presence: true

  validates :heading,
    length: { maximum: 255 },
    format: { with: /\S(.*)/ }

  validates :order,
    presence: true
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

