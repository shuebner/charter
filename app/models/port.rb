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

  # Häfen, an denen ein eigenes Schiff liegt
  scope :own, joins(boats: :owner).where('boat_owners.is_self').
    select('ports.*').group('ports.id')

  # Häfen, an denen ein fremdes Schiff aber kein eigenes Schiff liegt
  # (hat nicht als scope mit eingebautem Port.own.map(&:id) funktioniert)
  def self.external
    own_ids = own.map(&:id)
    joins(:boats).where('boats.id IS NOT NULL').
      where('ports.id NOT IN (:own_ids)', own_ids: own_ids).
      select('ports.*').group('ports.id')
  end

  def own?
    Boat.own.where(port_id: id).any?
  end

  private

  def no_boats_exist
    unless boats.empty?
      errors.add(:base, "Es existieren noch Schiffe an diesem Standort")
      return false
    end
  end
end
