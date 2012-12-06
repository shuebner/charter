class Attachment < ActiveRecord::Base
  attr_accessible :attachment_title, :attachment, :order,
    :remove_attachment, :retained_attachment

  file_accessor :attachment

  belongs_to :attachable, polymorphic: true
  
  validates :attachable_id, :attachable_type, :attachment_title,
    presence: true

  validates :order,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 1 },
    uniqueness: { scope: [:type, :attachable_type, :attachable_id] }

  before_save { self.attachment_title = sanitize(attachment_title, tags: []) }

  default_scope order('attachments.order ASC')

  delegate :url, to: :attachment

  def title
    attachment_title
  end
end
