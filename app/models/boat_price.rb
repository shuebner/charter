class BoatPrice < ActiveRecord::Base
  attr_accessible :value

  belongs_to :boat
  belongs_to :season
  belongs_to :boat_price_type

  validates :value,
    presence: true,
    numericality: { greater_than: 0 }

  validates :season, :boat,
    presence: true

  validates :boat_price_type_id,
    presence: true,
    uniqueness: { scope: [:boat_id, :season_id] }
end
