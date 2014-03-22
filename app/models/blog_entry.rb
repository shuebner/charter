class BlogEntry < ActiveRecord::Base  
  extend FriendlyId
  friendly_id :heading, use: :slugged
  
  attr_accessible :heading, :text, :blog_category_id

  include Activatable

  include Imageable
  imageable_image_class_name "BlogEntryImage"

  belongs_to :blog_category

  has_many :blog_entry_comments

  alias :comments :blog_entry_comments

  alias :category :blog_category

  def name
    heading
  end

  validates :heading,
    presence: true

  validates :text,
    presence: true

  scope :active, where(active: true)

  before_save do
    [:heading, :text].each do |a|
      self[a] = sanitize(self[a], tags: [])
    end
  end
end
