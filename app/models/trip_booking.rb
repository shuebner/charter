# encoding: utf-8
class TripBooking < ActiveRecord::Base
  extend FriendlyId
  friendly_id :number, use: :slugged

  attr_accessible :no_of_bunks, :trip_date, :customer

  belongs_to :customer
  belongs_to :trip_date

  before_save :generate_number

  validates :no_of_bunks,
    presence: true,
    numericality: { only_integer: true, 
      greater_than: 0,
      less_than_or_equal_to: Proc.new { |b| b.trip_date.no_of_available_bunks } }
  
  default_scope order("number DESC")

  scope :effective, 
    where("cancelled_at IS NULL")


  def cancel!
    self.cancelled_at = Time.now
  end

  
  private
  
  def self.highest_number_for_year(year)
    last_booking = where("number LIKE 'T-#{year}-%'").order("number DESC").first()
    if last_booking
      last_booking.number
    else
      "T-#{year}-001"
    end
  end
    
  def generate_number
    self.number = self.class.highest_number_for_year(trip_date.begin.year).succ      
  end
end
