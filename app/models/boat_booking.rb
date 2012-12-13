# encoding: utf-8
class BoatBooking < ActiveRecord::Base
  extend FriendlyId
  friendly_id :number, use: :slugged

  attr_accessible :adults, :begin_date, :children, :end_date

  belongs_to :customer
  belongs_to :boat

  validates :adults, :children, :begin_date, :end_date,
    :customer, :boat,
    presence: true

  validates :number,
    uniqueness: true
    
  validates :adults,
    numericality: { only_integer: true, greater_than: 0 }

  validates :children,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :people,
    numericality: { less_than_or_equal_to: lambda { |b| b.boat.max_no_of_people },
    if: lambda { |b| b.boat && b.boat.max_no_of_people } }

  validates :begin_date,
    timeliness: { type: :datetime }

  validates :end_date,
    timeliness: { type: :datetime, after: :begin_date }

  validate :boat_is_available, if: :boat

  default_scope order("begin_date ASC")

  def self.overlapping(reservation)
    if reservation.instance_of?(BoatBooking) && reservation.id
      where("TIMEDIFF(begin_date, :end_date) * TIMEDIFF(:begin_date, end_date) >= 0", 
        { begin_date: reservation.begin_date, end_date: reservation.end_date }).
        where("NOT boat_bookings.id = ?", reservation.id)
    else
      where("TIMEDIFF(begin_date, :end_date) * TIMEDIFF(:begin_date, end_date) >= 0", 
        { begin_date: reservation.begin_date, end_date: reservation.end_date })
    end  
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
        "#{I18n.l(begin_date)} - #{I18n.l(end_date)})"
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

      [:begin_date, :end_date].each do |d|
        errors.add(d, error_text)
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
    if begin_date
      self.class.highest_number_for_year(begin_date.year).succ
    end
  end
end
