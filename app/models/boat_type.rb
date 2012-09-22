class BoatType < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :boats, dependent: :destroy
  attr_accessible :manufacturer, :model, :length_hull, :length_waterline, :beam,
    :draft, :air_draft, :displacement, :sail_area_jib, :sail_area_genoa,
    :saile_area_main_sail, :tank_volume_diesel, :tank_volume_fresh_water,
    :tank_volume_waste_water, :permament_bunks, :convertible_bunks,
    :max_no_of_people, :recommended_no_of_people, :headroom_saloon
  
  validates :manufacturer, :model,
    presence: true

  validates :model, uniqueness: { scope: :manufacturer }
end
