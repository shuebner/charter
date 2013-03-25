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

  validates :deferred,
    inclusion: { in: [true, false] }  
  # Termin soll nur zurückstellbar sein, falls keine unstornierten Buchungen darauf existieren
  validate :no_effective_trip_bookings_exist, if: :deferred?

  validate :boat_is_available, unless: :deferred?

  validate :trip_has_no_other_trip_date, if: Proc.new { trip && trip.composite_trip }

  after_initialize do
    if self.new_record?
      self.deferred = false
    end
  end

  before_destroy :no_trip_bookings_exist

  def self.booked
    joins(:trip_bookings).merge(TripBooking.effective).uniq
  end

  def self.effective
    where("NOT deferred")
  end

  def self.overlapping(reservation)
    if reservation.instance_of?(TripDate)
      scope = effective.where("TIMEDIFF(start_at, :end_at) * TIMEDIFF(:start_at, end_at) >= 0", 
        { start_at: reservation.start_at, end_at: reservation.end_at })
      if reservation.id 
        scope = scope.where("NOT view_trip_dates.id = ?", reservation.id)
      end
    else
      scope = effective.where("TIMEDIFF(start_at, :end_at) * TIMEDIFF(:start_at, end_at) >= 0", 
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

  def deferred?
    deferred
  end

  def defer!
    self.deferred = true
  end

  def undefer!
    self.deferred = false
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

  def no_effective_trip_bookings_exist
    unless trip_bookings.effective.empty?
      errors.add(:deferred, "Für diesen Termin existieren unstornierte Buchungen")
    end
  end

  def trip_has_no_other_trip_date
    scope = trip.trip_dates.all
    unless new_record?
      scope = scope.where('id != ?', id)
    end
    if scope.any?
      errors.add(:trip, "Dieser Teiltörn eines Etappentörns hat bereits einen Termin")
    end
  end
end