class Image < Attachment

  image_accessor :attachment

  validates :type,
    presence: true
end