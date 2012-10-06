class Trip < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :name, :description, :no_of_bunks, :price, :boat_id,
    :trip_dates_attributes

  belongs_to :boat
  has_many :trip_dates, dependent: :destroy
  accepts_nested_attributes_for :trip_dates, allow_destroy: true

  validates :boat_id, :name, :description, :no_of_bunks, :price,
    presence: true

  validates :description,
    no_html: true

  default_scope order("name ASC")
end
