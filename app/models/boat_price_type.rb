class BoatPriceType < ActiveRecord::Base
  attr_accessible :duration, :name

  validates :name,
    presence: true,
    uniqueness: true

  validates :duration,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 }

  before_save { self.name = sanitize(name, tags: []) }
end
