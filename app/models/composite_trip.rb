class CompositeTrip < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged  

  include Activatable

  attr_accessible :active, :boat, :name, :slug

  belongs_to :boat

  has_many :trips, dependent: :destroy

  validates :name,
    presence: true

  validates :description,
    presence: true;

  before_save do
    [:name, :description].each do |a|
      self[a] = sanitize(self[a], tags: [])
    end
  end    
end
