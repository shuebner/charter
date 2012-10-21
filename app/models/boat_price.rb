# encoding: utf-8
class BoatPrice < ActiveRecord::Base
  attr_accessible :value, :boat_id, :season_id, :boat_price_type_id

  belongs_to :boat
  belongs_to :season
  belongs_to :boat_price_type

  validates :value,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  validates :season, :boat,
    presence: true

  validates :boat_price_type_id,
    presence: true,
    uniqueness: { scope: [:boat_id, :season_id] }

  validate :boat_is_available_for_boat_charter, if: :boat

  
  def ==(other)
    other.instance_of?(BoatPrice) &&
      value == other.value && boat == other.boat && 
      boat_price_type == other.boat_price_type && season == other.season        
  end

  private

  def boat_is_available_for_boat_charter
    unless boat.available_for_boat_charter
      errors.add(:boat, "ist nicht für Bootscharter verfügbar")
    end
  end
end
