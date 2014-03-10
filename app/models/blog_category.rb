# encoding: utf-8
class BlogCategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :name

  has_many :blog_entries
  alias :entries :blog_entries

  validates :name,
    presence: true

  before_save do
    self.name = sanitize(self.name, tags: [])
  end

  before_destroy :no_blog_entries_exist

  private
  def no_blog_entries_exist
    unless entries.empty?
      errors.add(:base, "Kategorie kann nicht gelöscht werden, solange zugehörige Blog-Einträge existieren")
      return false
    end
  end
end
