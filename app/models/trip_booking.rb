# encoding: utf-8
class TripBooking < ActiveRecord::Base
  extend FriendlyId
  friendly_id :number, use: :slugged

  attr_accessible :no_of_bunks, :trip_date_id, :customer_id

  belongs_to :customer
  belongs_to :trip_date

  delegate :trip, to: :trip_date

  before_destroy  { return false }

  validates :no_of_bunks,
    presence: true,
    numericality: { only_integer: true, 
      greater_than: 0,
      less_than_or_equal_to: Proc.new { |b| b.trip_date.no_of_available_bunks } }

  validates :number,
    presence: true,
    uniqueness: true
  
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
    self.class.highest_number_for_year(trip_date.begin.year).succ      
  end
end
