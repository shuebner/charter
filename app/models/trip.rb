# encoding: utf-8
class Trip < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  include Activatable

  include Imageable
  imageable_image_class_name "TripImage"

  attr_accessible :name, :description, :no_of_bunks, :price, :boat_id,
    :trip_dates_attributes, :composite_trip_id

  belongs_to :boat

  belongs_to :composite_trip
  
  has_many :trip_dates
  validate :has_at_most_one_trip_date, if: :composite_trip

  before_destroy :no_trip_dates_exist

  accepts_nested_attributes_for :trip_dates, allow_destroy: true

  validates :boat_id, :name, :description, :no_of_bunks, :price,
    presence: true

  validates :price,
    numericality: { greater_than_or_equal_to: 0 }

  validates :no_of_bunks,
    numericality: { only_integer: true, greater_than: 0 }
  validates :no_of_bunks,
    numericality: { less_than: Proc.new { |t| t.boat.max_no_of_bunks }, if: :boat }

  validate :boat_is_available_for_bunk_charter, if: :boat

  validate :boat_should_be_same_as_for_composite_trip, if: :composite_trip

  scope :visible, where(active: true)

  scope :single, where("composite_trip_id IS NULL")

  before_save do
    [:name, :description].each do |a|
      self[a] = sanitize(self[a], tags: [])
    end
  end

  def composite_trip=(ctrip)
    self.boat = ctrip.boat
    super
  end

  def display_name
    name
  end


  private
  def boat_is_available_for_bunk_charter
    unless boat.available_for_bunk_charter
      errors.add(:boat, "ist nicht für Kojencharter verfügbar")
    end    
  end

  def no_trip_dates_exist
    unless trip_dates.empty?
      errors.add(:base, "Es sind bereits Törntermine vorhanden.")
      return false
    end
  end

  def boat_should_be_same_as_for_composite_trip
    unless boat_id == composite_trip.boat_id
      errors.add(:boat, "Muss gleich dem Schiff des Etappentörns sein")
    end
  end

  def has_at_most_one_trip_date
    unless trip_dates.count <= 1
      errors.add(:composite_trip, "Teiltörn eines Etappentörns darf maximal einen Termin haben")
    end
  end
end
