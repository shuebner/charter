class Boat < ActiveRecord::Base
  belongs_to :boat_type
  attr_accessible :name, :slug, :year_of_construction, :year_of_refit,
    :engine_manufacturer, :engine_model, :engine_design, :engine_output,
    :battery_capacity, :available_for_boat_charter, :available_for_bunk_charter,
    :deposit, :cleaning_charge, :fuel_charge, :gas_charge

  validates :name, :slug, :year_of_construction,
    presence: true

  validates :available_for_boat_charter, :available_for_bunk_charter,
    inclusion: { in: [true, false] }

  before_validation :generate_slug

  protected
    def generate_slug
      if slug.blank?
        self.slug = name.parameterize
      else
        self.slug = slug.parameterize
      end
    end
end
