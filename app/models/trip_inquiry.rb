class TripInquiry < Inquiry  
  acts_as_citier
  attr_accessible :bunks

  belongs_to :trip_date

  validates :bunks,
    presence: true,
    numericality: { only_integer: true, 
      greater_than: 0 }
  validates :bunks,
    numericality: {
      less_than_or_equal_to: Proc.new { |i| i.trip_date.no_of_available_bunks },
      if: :trip_date }

  validates :trip_date,
    presence: true
end
