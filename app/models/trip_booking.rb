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
      less_than_or_equal_to: Proc.new { |b| b.trip_date.no_of_available_bunks },
      if: :trip_date }

  validates :number,
    uniqueness: true

  validates :customer,
    presence: true

  validates :trip_date,
    presence: true
  
  default_scope order("number DESC")

  scope :effective, 
    where("cancelled_at IS NULL")


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
