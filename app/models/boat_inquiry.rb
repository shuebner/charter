class BoatInquiry < Inquiry
  acts_as_citier
  attr_accessible :adults, :begin_date, :children, :end_date

  belongs_to :boat

  validates :adults,
    numericality: { only_integer: true, greater_than: 0 }

  validates :children,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :begin_date,
    timeliness: { type: :date }

  validates :end_date,
    timeliness: { type: :date, after: :begin_date }
end
