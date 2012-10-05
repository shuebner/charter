class TripDate < ActiveRecord::Base
  attr_accessible :begin, :end

  belongs_to :trip

  validates :begin, :end,
    presence: true

  validate :begin_lies_before_end

  default_scope order("begin ASC")

  private
  def begin_lies_before_end
    if self.begin && self.end
      unless self.begin < self.end
        errors.add(:end,'muss nach dem Anfangszeitpunkt liegen')
      end
    end
  end
end