class Port < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :name, :slug

  has_many :boats

  validates :name,
    presence: true,
    uniqueness: true

  before_destroy :no_boats_exist

  private

  def no_boats_exist
    unless boats.empty?
      errors.add(:base, "Es existieren noch Schiffe an diesem Standort")
      return false
    end
  end
end
