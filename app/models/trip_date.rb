# encoding: utf-8
class TripDate < ActiveRecord::Base
  attr_accessible :begin, :end

  belongs_to :trip

  has_many :trip_bookings

  validates :begin, :end,
    presence: true

  validate :begin_lies_before_end

  validate :no_overlap_at_same_boat

  default_scope order("begin ASC")

  def self.overlapping(date)
    if date.id
      where("begin BETWEEN :begin AND :end OR end BETWEEN :begin AND :end", 
        { begin: date.begin, end: date.end }).
        where("NOT trip_dates.id = ?", date.id)
    else
      where("begin BETWEEN :begin AND :end OR end BETWEEN :begin AND :end", 
        { begin: date.begin, end: date.end })
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
  
  private
  def begin_lies_before_end
    if self.begin && self.end
      unless self.begin < self.end
        errors.add(:end,'muss nach dem Anfangszeitpunkt liegen')
      end
    end
  end

  def no_overlap_at_same_boat
    unless trip.boat.trip_dates.overlapping(self).empty?
      overlapping_dates = trip.boat.trip_dates.overlapping(self)
      
      error_text = "Termin überschneidet sich mit: "
      overlapping_dates.each do |d|
        error_text << "#{d.trip.name} (#{I18n.l(d.begin)} - #{I18n.l(d.end)}) "
      end
      
      errors.add(:begin, error_text)
      errors.add(:end, error_text)
    end
  end
end