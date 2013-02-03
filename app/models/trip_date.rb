# encoding: utf-8
class TripDate < Appointment#ActiveRecord::Base
  acts_as_citier

  belongs_to :trip

  has_many :trip_bookings

  validates :start_at,
    presence: true,
    timeliness: { type: :datetime }

  validates :end_at,
    presence: true,
    timeliness: { type: :datetime, after: :start_at }

  validate :boat_is_available

  before_destroy :no_trip_bookings_exist

  def self.booked
    joins(:trip_bookings).merge(TripBooking.effective).uniq
  end

  def self.overlapping(reservation)
    if reservation.instance_of?(TripDate)
      scope = where("TIMEDIFF(start_at, :end_at) * TIMEDIFF(:start_at, end_at) >= 0", 
        { start_at: reservation.start_at, end_at: reservation.end_at })
      if reservation.id 
        scope = scope.where("NOT view_trip_dates.id = ?", reservation.id)
      end
    else
      scope = where("TIMEDIFF(start_at, :end_at) * TIMEDIFF(:start_at, end_at) >= 0", 
        { start_at: reservation.start_at, end_at: reservation.end_at })
    end
    scope
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
    "#{I18n.l(start_at)} - #{I18n.l(end_at)}"
  end

  def display_name_with_trip
    "#{trip.name} (#{display_name})"
  end

  def color
    trip.boat.color
  end
  
  private
  
  def boat_is_available
    unless trip.boat.available_for_reservation?(self)
      overlap = trip.boat.overlapping_reservations(self)
      trip_dates = overlap[:trip_dates]
      boat_bookings = overlap[:boat_bookings]

      error_text = "Termin überschneidet sich mit: "
      if trip_dates.any?
        error_text << "Törnterminen ("
        trip_dates.each do |d|
          error_text << "#{d.display_name_with_trip} "
        end        
        error_text << ")"
      end
      
      if boat_bookings.any?
        error_text << " Schiffsbuchungen ("
        boat_bookings.each do |b|
          error_text << "#{b.display_name} "
        end
        error_text << ")"
      end

      [:start_at, :end_at].each do |d|
        errors.add(d, error_text)
      end
    end
  end

  def no_trip_bookings_exist
    unless trip_bookings.empty?
      errors.add(:base, "Für diesen Termin existieren bereits Buchungen.")
      return false
    end
  end
end