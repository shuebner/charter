class BlogCategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :name

  validates :name,
    presence: true

  before_save do
    self.name = sanitize(self.name, tags: [])
  end
end
