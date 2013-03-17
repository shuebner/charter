# encoding: utf-8

class PartnerImage < Image

  image_accessor :attachment do
    storage_path { |a| "partner/images/#{rand(100)}_#{a.name}" }
  end

  validate :no_other_image_already_exists_for_partner, if: :attachable

  after_initialize do
    if new_record?
      self.order = 1
    end
  end


  private

  def no_other_image_already_exists_for_partner
    scope = PartnerImage.where(attachable_id: attachable.id)
    unless new_record?
      scope = scope.where("id != ?", id)
    end
    if scope.any?
      errors.add(:attachable_id, "Es existiert bereits ein Bild für diesen Partner")
    end    
  end
end
