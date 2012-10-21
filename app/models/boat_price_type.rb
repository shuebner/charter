class BoatPriceType < ActiveRecord::Base
  attr_accessible :duration, :name

  has_many :boat_prices, dependent: :destroy

  validates :name,
    presence: true,
    uniqueness: true

  validates :duration,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 }

  default_scope order("duration ASC, name ASC")

  before_save { self.name = sanitize(name, tags: []) }
end
