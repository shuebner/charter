class BlogEntryComment < ActiveRecord::Base
  attr_accessible :author, :text

  belongs_to :blog_entry
  alias :entry :blog_entry

  delegate :category, to: :blog_entry

  validates :author,
    presence: true,
    length: { maximum: 50 }

  validates :text,
    presence: true,
    length: { minimum: 5, maximum: 1000 }

  before_save do
    [:author, :text].each do |a|
      self[a] = sanitize(self[a], tags: [])
    end
  end
end
