class BlogEntryComment < ActiveRecord::Base
  attr_accessible :author, :text

  belongs_to :blog_entry
  alias :entry :blog_entry

  validates :author,
    presence: true

  validates :text,
    presence: true

  before_save do
    [:author, :text].each do |a|
      self[a] = sanitize(self[a], tags: [])
    end
  end
end
