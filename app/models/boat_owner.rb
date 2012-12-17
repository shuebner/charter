class BoatOwner < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :is_self, :name

  has_many :boats

  before_destroy :has_no_boats

  validates :name,
    presence: true,
    uniqueness: true

  validates :is_self,
    inclusion: { in: [true, false] }

  private

  def has_no_boats
    unless boats.empty?
      errors.add(:base, "Es existieren noch Schiffe dieses Eigners")
      return false
    end
  end
end
