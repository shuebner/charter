# encoding: utf-8
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

  validates :price,
    numericality: { greater_than_or_equal_to: 0 }

  validates :no_of_bunks,
    numericality: { only_integer: true, greater_than: 0 }
  validates :no_of_bunks,
    numericality: { less_than: Proc.new { |t| t.boat.max_no_of_bunks }, if: :boat }

  validate :boat_is_available_for_bunk_charter, if: :boat

  default_scope order("name ASC")

  before_save do
    [:name, :description].each do |a|
      self[a] = sanitize(self[a], tags: [])
    end
  end

  private
  def boat_is_available_for_bunk_charter
    unless boat.available_for_bunk_charter
      errors.add(:boat, "ist nicht für Kojencharter verfügbar")
    end    
  end
end
