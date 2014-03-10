class BlogEntry < ActiveRecord::Base  
  extend FriendlyId
  friendly_id :heading, use: :slugged
  
  attr_accessible :heading, :text

  include Activatable

  include Imageable
  imageable_image_class_name "BlogEntryImage"

  validates :heading,
    presence: true

  validates :text,
    presence: true

  before_save do
    [:heading, :text].each do |a|
      self[a] = sanitize(self[a], tags: [])
    end
  end
end
