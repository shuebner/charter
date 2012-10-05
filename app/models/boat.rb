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

  validates :manufacturer, :model, :name, :slug, :year_of_construction,
    presence: true

  validates :available_for_boat_charter, :available_for_bunk_charter,
    inclusion: { in: [true, false] }

  default_scope order("name ASC")

  scope :visible, 
    where("available_for_boat_charter = ? OR available_for_bunk_charter = ?",
        true, true)

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

  def visible?
    available_for_bunk_charter || available_for_boat_charter
  end
end
