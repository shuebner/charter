# encoding: utf-8
class BoatBooking < Appointment
  acts_as_citier

  extend FriendlyId
  extend FriendlyIdBaseClassPatch
  friendly_id :number, use: :slugged

  attr_accessible :adults, :children, :customer_number, :boat_id

  belongs_to :customer, foreign_key: :customer_number, primary_key: :number
  belongs_to :boat

  validates :adults, :children, :customer, :boat,
    presence: true

  validates :number,
    uniqueness: true
    
  validates :adults,
    numericality: { only_integer: true, greater_than: 0 }

  validates :children,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :max_no_of_people_on_boat_is_not_exceeded

  validate :boat_is_available, if: :boat

  # cancellation mechanic
  validates :cancelled,
    inclusion: { in: [true, false] }

  after_initialize do
    if self.has_attribute?(:cancelled)
      if self.new_record?
        self.cancelled = false
      end
      if cancelled?
        self.readonly!
      end
    end
  end

  after_save do
    if cancelled?
      self.readonly!
    end
  end

  scope :effective, where(cancelled: false)

  def self.overlapping(reservation)
    if reservation.instance_of?(BoatBooking)
      scope = effective.where("TIMEDIFF(start_at, :end_at) * TIMEDIFF(:start_at, end_at) >= 0", 
        { start_at: reservation.start_at, end_at: reservation.end_at })
      if reservation.id
      	scope = scope.where("NOT view_boat_bookings.id = ?", reservation.id)
      end
    else
      scope = effective.where("TIMEDIFF(start_at, :end_at) * TIMEDIFF(:start_at, end_at) >= 0", 
        { start_at: reservation.start_at, end_at: reservation.end_at })
    end
    scope
  end

  def people
    (adults || 0) + (children || 0)
  end

  def number
    unless self[:number]
      self[:number] = generate_number
    end
    self[:number]
  end

  def display_name
    "#{customer.display_name} ("\
        "#{I18n.l(start_at)} - #{I18n.l(end_at)})"
  end

  def cancel!
    self.cancelled = true
  end

  def cancelled?
    cancelled
  end
  
  private

  def boat_is_available
    unless boat.available_for_reservation?(self)
      overlap = boat.overlapping_reservations(self)
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

  def max_no_of_people_on_boat_is_not_exceeded
    if boat && boat.max_no_of_people && (adults || children)
      unless people <= boat.max_no_of_people
        error_text = "Es dürfen maximal #{boat.max_no_of_people} Personen auf dem Schiff sein"
        errors.add(:adults, error_text)
        errors.add(:children, error_text)
      end
    end
  end
  
  def self.highest_number_for_year(year)
    last_booking = where("number LIKE 'B-#{year}-%'").order("number DESC").first()
    if last_booking
      last_booking.number
    else
      "B-#{year}-000"
    end
  end
    
  def generate_number
    if start_at
      self.class.highest_number_for_year(start_at.year).succ
    end
  end
end
