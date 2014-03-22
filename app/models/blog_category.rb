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

  scope :by_time, order('updated_at DESC')

  def self.latest
    latest_entry = BlogEntry.order('updated_at DESC').limit(1).first
    if latest_entry
      latest_entry.blog_category
    else
      order('updated_at DESC').limit(1).first
    end
  end

  def self.others(category)
    where('id <> ?', category.id)
  end

  private
  def no_blog_entries_exist
    unless entries.empty?
      errors.add(:base, "Kategorie kann nicht gelöscht werden, solange zugehörige Blog-Einträge existieren")
      return false
    end
  end
end
