# encoding: utf-8
class TripDate < ActiveRecord::Base
  attr_accessible :begin, :end

  belongs_to :trip

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
      errors.add(:begin, 'Termin überschneidet sich')
      errors.add(:end, 'Termin überschneidet sich')
    end
  end
end