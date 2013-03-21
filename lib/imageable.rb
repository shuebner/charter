module Imageable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def imageable_image_class_name(image_class_name)
      has_many :images, as: :attachable, class_name: image_class_name,
        dependent: :destroy
      accepts_nested_attributes_for :images, allow_destroy: true
      attr_accessible :images_attributes
    end
  end

  def title_image
    unless images.empty?
      images.first
    end
  end

  def other_images
    images.offset(1)
  end
end