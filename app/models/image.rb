class Image < Attachment

  image_accessor :attachment do
    after_assign :resize_image
  end

  delegate :thumb, to: :attachment

  validates :type,
    presence: true

  private

  def resize_image
    attachment.process!(:resize, '1600x1200>')
  end
end