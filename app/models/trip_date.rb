# encoding: utf-8
class TripDate < ActiveRecord::Base
  attr_accessible :begin, :end

  belongs_to :trip

  has_many :trip_bookings

  validates :begin,
    presence: true,
    timeliness: { type: :datetime }

  validates :end,
    presence: true,
    timeliness: { type: :datetime, after: :begin }

  validate :no_overlap_at_same_boat

  before_destroy :no_trip_bookings_exist

  default_scope order("begin ASC")

  def self.overlapping(trip_date)
    if trip_date.id
      where("DATEDIFF(begin, :end) * DATEDIFF(:begin, end) >= 0", 
        { begin: trip_date.begin, end: trip_date.end }).
        where("NOT id = ?", trip_date.id)
    else
      where("DATEDIFF(begin, :end) * DATEDIFF(:begin, end) >= 0", 
        { begin: trip_date.begin, end: trip_date.end })
    end  
  end

  def no_of_available_bunks
    if trip_bookings.effective.any?
      booked_bunks = trip_bookings.effective.map(&:no_of_bunks).inject(:+)
    else
      booked_bunks = 0
    end
    trip.no_of_bunks - booked_bunks
  end

  def display_name
    "#{I18n.l(self.begin)} - #{I18n.l(self.end)}"
  end

  def display_name_with_trip
    "#{trip.name} (#{display_name})"
  end
  
  private
  
  def no_overlap_at_same_boat
    unless trip.boat.trip_dates.overlapping(self).empty?
      overlapping_dates = trip.boat.trip_dates.overlapping(self)
      
      error_text = "Termin überschneidet sich mit: "
      overlapping_dates.each do |d|
        error_text << "#{d.display_name_with_trip} "
      end
      
      errors.add(:begin, error_text)
      errors.add(:end, error_text)
    end
  end

  def no_trip_bookings_exist
    unless trip_bookings.empty?
      errors.add(:base, "Für diesen Termin existieren bereits Buchungen.")
      return false
    end
  end
end