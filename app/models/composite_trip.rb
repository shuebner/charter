class CompositeTrip < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged  

  include Activatable

  include Imageable
  imageable_image_class_name "CompositeTripImage"

  attr_accessible :active, :boat_id, :description, :name, :slug

  belongs_to :boat

  has_many :trips, dependent: :destroy

  validates :boat_id,
    presence: true

  validates :name,
    presence: true

  validates :description,
    presence: true

  before_save do
    [:name, :description].each do |a|
      self[a] = sanitize(self[a], tags: [])
    end
  end

  scope :visible, where(active: true)

  scope :active, where(active: true)
end
