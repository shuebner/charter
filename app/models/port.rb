class Port < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :name, :slug

  has_many :boats

  validates :name,
    presence: true,
    uniqueness: true

  before_destroy :no_boats_exist

  default_scope order("name ASC")

  scope :with_visible_boat, joins(:boats).merge(Boat.visible).
    select('ports.*').group('ports.id')

  scope :own, joins(boats: :owner).where('boat_owners.is_self = TRUE').
    select('ports.*').group('ports.id')

  scope :external, joins(boats: :owner).where('boat_owners.is_self = FALSE').
    select('ports.*').group('ports.id')

  private

  def no_boats_exist
    unless boats.empty?
      errors.add(:base, "Es existieren noch Schiffe an diesem Standort")
      return false
    end
  end
end
