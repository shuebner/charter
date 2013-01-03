class Appointment < ActiveRecord::Base
  attr_accessible :end_at, :start_at

  validates :start_at,
    presence: true,
    timeliness: { type: :datetime }

  validates :end_at,
    presence: true,
    timeliness: { type: :datetime, after: :start_at }
end
