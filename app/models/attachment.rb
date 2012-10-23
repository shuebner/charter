class Attachment < ActiveRecord::Base
  attr_accessible :attachment_title, :attachment,
    :remove_attachment, :retained_attachment

  file_accessor :attachment

  belongs_to :attachable, polymorphic: true
  
  validates :attachable_id, :attachable_type, :attachment_title,
    presence: true

  before_save { self.attachment_title = sanitize(attachment_title, tags: []) }
end
