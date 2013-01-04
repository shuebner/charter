class Appointment < ActiveRecord::Base
  acts_as_citier

  attr_accessible :end_at, :start_at

  validates :start_at,
    presence: true,
    timeliness: { type: :datetime }

  validates :end_at,
    presence: true,
    timeliness: { type: :datetime, after: :start_at }
end
