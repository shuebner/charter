class Setting < ActiveRecord::Base
  attr_accessible :key, :value

  validates :key, :value,
    presence: true
end
