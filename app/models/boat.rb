# encoding: utf-8
class Boat < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :manufacturer, :model, 
    :length_hull, :length_waterline, :beam, :draft, :air_draft, :displacement, 
    :sail_area_jib, :sail_area_genoa, :sail_area_main_sail, 
    :tank_volume_diesel, :tank_volume_fresh_water, :tank_volume_waste_water, 
    :permanent_bunks, :convertible_bunks, 
    :max_no_of_people, :recommended_no_of_people, 
    :headroom_saloon,
    :name, :slug, 
    :year_of_construction, :year_of_refit,
    :engine_manufacturer, :engine_model, :engine_design, :engine_output,
    :battery_capacity, 
    :available_for_boat_charter, :available_for_bunk_charter,
    :deposit, :cleaning_charge, :fuel_charge, :gas_charge

  has_many :trips, dependent: :destroy

  has_many :trip_dates, through: :trips

  has_many :boat_prices, dependent: :destroy

  has_many :images, as: :attachable, class_name: "BoatImage", 
    dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  attr_accessible :images_attributes

  has_many :documents, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :documents, allow_destroy: true
  attr_accessible :documents_attributes

  # Dezimalzahlen können entweder leer oder müssen >=0 sein
  validates :length_hull, :length_waterline, :beam, :draft, :air_draft, :displacement, 
    :sail_area_jib, :sail_area_genoa, :sail_area_main_sail, 
    :headroom_saloon, 
    :deposit, :cleaning_charge, :fuel_charge, :gas_charge,    
    allow_nil: true,
    numericality: { greater_than_or_equal_to: 0 }

  # Ganze Zahlen können entweder leer oder müssen >= 0 sein
  validates :tank_volume_diesel, :tank_volume_fresh_water, :tank_volume_waste_water, 
    :permanent_bunks, :convertible_bunks, 
    :max_no_of_people, :recommended_no_of_people, 
    :year_of_refit, :engine_output,
    allow_nil: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :year_of_construction, 
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :manufacturer, :model, :name, :slug,
    presence: true

  validates :available_for_boat_charter, :available_for_bunk_charter,
    inclusion: { in: [true, false] }

  validates :available_for_bunk_charter, if: 'trips.any?',
    inclusion: { in: [true], 
      message: 'es sind noch Törns mit diesem Schiff vorhanden' }

  validates :deposit, :cleaning_charge, :fuel_charge,
    presence: { if: :available_for_boat_charter }

  validates :deposit, :cleaning_charge, :fuel_charge, :gas_charge,
    no_presence: { unless: :available_for_boat_charter }

  default_scope order("name ASC")

  scope :visible, 
    where("available_for_boat_charter = ? OR available_for_bunk_charter = ?",
        true, true)

  scope :bunk_charter_only,
    where(available_for_bunk_charter: true)

  scope :boat_charter_only,
    where(available_for_boat_charter: true)

  before_save do
    [:manufacturer, :model, :name, 
     :engine_manufacturer, :engine_model, :engine_design].each do |a|
      self[a] = sanitize(self[a], tags: [])
    end
  end

  def total_sail_area_with_jib
    if sail_area_jib && sail_area_main_sail
      sail_area_main_sail + sail_area_jib
    end
  end

  def total_sail_area_with_genoa
    if sail_area_main_sail && sail_area_genoa
      sail_area_main_sail + sail_area_genoa
    end
  end

  def max_no_of_bunks
    if permanent_bunks && convertible_bunks
      permanent_bunks + convertible_bunks
    end
  end

  def visible?
    available_for_bunk_charter || available_for_boat_charter
  end

  # gibt zurück, ob der durch begin_date und end_date in reservation 
  # angegebene Zeitraum mit einer anderen (!) das Schiff betreffenden
  # Reservierung kollidiert
  def available_for_reservation?(reservation)
    trip_dates.overlapping(reservation).empty? 
  end

  def overlapping_reservations(reservation)
    trip_dates.overlapping(reservation)
  end

  def prices(season, type)
    boat_prices.where(season_id: season.id, boat_price_type_id: type.id).first
  end

  def title_image
    unless images.empty?
      images.first
    end
  end

  def other_images
    images.offset(1)
  end
end
