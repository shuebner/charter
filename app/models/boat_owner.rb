class BoatOwner < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :is_self, :name

  validates :name,
    presence: true,
    uniqueness: true

  validates :is_self,
    inclusion: { in: [true, false] }
end
