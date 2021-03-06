# encoding: utf-8
class TripBooking < ActiveRecord::Base
  extend FriendlyId
  friendly_id :number, use: :slugged

  attr_accessible :no_of_bunks, :trip_date_id, :customer_number

  belongs_to :customer, foreign_key: :customer_number, primary_key: :number
  belongs_to :trip_date

  delegate :trip, to: :trip_date

  before_destroy  { return false }

  validates :no_of_bunks,
    presence: true,
    numericality: { only_integer: true, 
      greater_than: 0 }
  
  validates :no_of_bunks,
    numericality: {
      less_than_or_equal_to: Proc.new do |b|        
        if b.new_record?
          b.trip_date.no_of_available_bunks
        else
          # beide Summanden sind die alten Werte aus der DB,
          # d. h. berücksichtigen nicht den evtl. geänderten Wert no_of_bunks von b
          # das ist für die Korrektheit der Berechnung notwendig!
          b.trip_date.no_of_available_bunks + TripBooking.find_by_id(b.id).no_of_bunks
        end
      end,
      if: :trip_date }

  validates :number,
    uniqueness: true

  validates :customer,
    presence: true

  validates :trip_date,
    presence: true

  # cancellation mechanic
  after_initialize do
    if self.has_attribute?(:cancelled)
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

  default_scope order("number DESC")

  scope :effective, 
    where("cancelled_at IS NULL")

  scope :in_current_period,
    joins(:trip_date).merge(TripDate.in_current_period)

  def cancel!
    unless cancelled?
      self.cancelled_at = Time.now
    end
  end

  def cancelled?
    !cancelled_at.blank?
  end

  def number
    unless self[:number]
      self[:number] = generate_number
    end
    self[:number]
  end
  
  private
  
  def self.highest_number_for_year(year)
    last_booking = where("number LIKE 'T-#{year}-%'").order("number DESC").first()
    if last_booking
      last_booking.number
    else
      "T-#{year}-000"
    end
  end
    
  def generate_number
    if trip_date
      self.class.highest_number_for_year(trip_date.start_at.year).succ
    end
  end
end
